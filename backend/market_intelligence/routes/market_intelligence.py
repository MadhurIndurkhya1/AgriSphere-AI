"""Member 5: Market Intelligence endpoints for AgriSphere AI.

Register this blueprint in the existing Flask application; see the module README.
"""
from datetime import date
from decimal import Decimal, InvalidOperation
from flask import Blueprint, jsonify, request
from db import get_db_connection

market_bp = Blueprint("market_intelligence", __name__, url_prefix="/api/market-intelligence")

def _json_value(value):
    if isinstance(value, Decimal):
        return float(value)
    if hasattr(value, "isoformat"):
        return value.isoformat()
    return value

def _rows(cursor):
    return [{key: _json_value(value) for key, value in row.items()} for row in cursor.fetchall()]

def _error(message, status=500):
    return jsonify({"success": False, "message": message}), status

def _read_query(sql, params=()):
    connection = get_db_connection()
    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute(sql, params)
        return _rows(cursor)
    finally:
        try: cursor.close()
        except Exception: pass
        connection.close()

@market_bp.get("/health")
def health():
    try:
        rows = _read_query("SELECT 1 AS database_connected")
        return jsonify({"success": True, "module": "market-intelligence", "database": "connected" if rows else "unknown"})
    except Exception:
        return _error("Market Intelligence database is not configured or reachable", 503)

@market_bp.get("/markets")
def get_markets():
    city = request.args.get("city", "").strip()
    try:
        sql = "SELECT id, name, city, state, address, market_type, opening_time, closing_time, contact_phone FROM mi_markets WHERE is_active = 1"
        params = ()
        if city:
            sql += " AND (city LIKE %s OR state LIKE %s)"
            params = (f"%{city}%", f"%{city}%")
        sql += " ORDER BY name LIMIT 100"
        return jsonify({"success": True, "data": _read_query(sql, params)})
    except Exception:
        return _error("Unable to load markets. Check database setup.", 503)

@market_bp.get("/listings")
def get_listings():
    crop = request.args.get("crop", "").strip()
    city = request.args.get("city", "").strip()
    try:
        sql = "SELECT l.id, l.crop_name, l.variety, l.quantity_kg, l.price_per_kg, l.quality_grade, l.description, l.created_at, s.name AS seller_name, s.phone AS seller_phone, s.city, s.state FROM mi_crop_listings l JOIN mi_buyers_sellers s ON s.id = l.seller_id WHERE l.status = 'available'"
        params = []
        if crop:
            sql += " AND l.crop_name LIKE %s"; params.append(f"%{crop}%")
        if city:
            sql += " AND (s.city LIKE %s OR s.state LIKE %s)"; params.extend([f"%{city}%", f"%{city}%"])
        sql += " ORDER BY l.created_at DESC LIMIT 100"
        return jsonify({"success": True, "data": _read_query(sql, tuple(params))})
    except Exception:
        return _error("Unable to load crop listings. Check database setup.", 503)

@market_bp.post("/listings")
def create_listing():
    data = request.get_json(silent=True) or {}
    required = ("seller_id", "crop_name", "quantity_kg", "price_per_kg")
    missing = [field for field in required if data.get(field) in (None, "")]
    if missing:
        return _error("Required fields: " + ", ".join(missing), 400)
    try:
        quantity = Decimal(str(data["quantity_kg"]))
        price = Decimal(str(data["price_per_kg"]))
        seller_id = int(data["seller_id"])
        if quantity <= 0 or price <= 0 or seller_id <= 0:
            return _error("Seller ID, quantity and price must be positive", 400)
    except (ValueError, InvalidOperation):
        return _error("Seller ID, quantity and price must be valid numbers", 400)
    connection = None
    try:
        connection = get_db_connection(); cursor = connection.cursor()
        cursor.execute("SELECT id FROM mi_buyers_sellers WHERE id=%s AND role IN ('seller','both') AND is_active=1", (seller_id,))
        if not cursor.fetchone():
            return _error("Active seller was not found", 404)
        cursor.execute("INSERT INTO mi_crop_listings (seller_id, crop_name, variety, quantity_kg, price_per_kg, quality_grade, description) VALUES (%s,%s,%s,%s,%s,%s,%s)", (seller_id, data["crop_name"].strip(), data.get("variety"), float(quantity), float(price), data.get("quality_grade", "Standard"), data.get("description")))
        connection.commit(); listing_id = cursor.lastrowid; cursor.close()
        return jsonify({"success": True, "message": "Crop listing created", "listing_id": listing_id}), 201
    except Exception:
        if connection: connection.rollback()
        return _error("Could not create listing. Verify seller and database setup.", 503)
    finally:
        if connection: connection.close()

@market_bp.get("/buyers-sellers")
def get_buyers_sellers():
    role = request.args.get("role", "").strip().lower()
    if role and role not in ("buyer", "seller", "both"):
        return _error("role must be buyer, seller or both", 400)
    try:
        sql = "SELECT id, name, role, phone, email, city, state, business_name FROM mi_buyers_sellers WHERE is_active=1"
        params = ()
        if role:
            sql += " AND role=%s"; params = (role,)
        sql += " ORDER BY name LIMIT 100"
        return jsonify({"success": True, "data": _read_query(sql, params)})
    except Exception:
        return _error("Unable to load buyer/seller directory", 503)

@market_bp.get("/price-prediction/<string:crop_name>")
def price_prediction(crop_name):
    """Transparent baseline forecast: average of up to 6 latest observations. Not an ML model."""
    try:
        rows = _read_query("SELECT market_date, modal_price_per_kg FROM mi_price_history WHERE crop_name=%s ORDER BY market_date DESC LIMIT 6", (crop_name,))
        if not rows:
            return _error("No historical price observations are available for this crop yet", 404)
        prices = [float(row["modal_price_per_kg"]) for row in rows]
        average = round(sum(prices) / len(prices), 2)
        return jsonify({"success": True, "crop": crop_name, "currency": "INR", "unit": "per kg", "method": "mean of latest available observations", "observations": len(prices), "estimated_reference_price": average, "history": rows, "disclaimer": "This is a simple historical-average reference, not a trained machine-learning forecast or a guarantee of future market price."})
    except Exception:
        return _error("Unable to calculate price reference", 503)

@market_bp.get("/cold-storage")
def get_cold_storage():
    city = request.args.get("city", "").strip()
    try:
        sql = "SELECT id, name, city, state, address, capacity_tonnes, available_capacity_tonnes, temperature_range, price_per_tonne_day, contact_phone FROM mi_cold_storage WHERE is_active=1 AND available_capacity_tonnes > 0"
        params = ()
        if city:
            sql += " AND (city LIKE %s OR state LIKE %s)"; params = (f"%{city}%", f"%{city}%")
        sql += " ORDER BY city, name LIMIT 100"
        return jsonify({"success": True, "data": _read_query(sql, params)})
    except Exception:
        return _error("Unable to load cold-storage facilities", 503)

@market_bp.get("/transport")
def get_transport():
    city = request.args.get("city", "").strip()
    try:
        sql = "SELECT id, provider_name, vehicle_type, city, state, service_area, load_capacity_tonnes, price_per_km, contact_phone FROM mi_transport_providers WHERE is_active=1"
        params = ()
        if city:
            sql += " AND (city LIKE %s OR state LIKE %s OR service_area LIKE %s)"; params = (f"%{city}%", f"%{city}%", f"%{city}%")
        sql += " ORDER BY provider_name LIMIT 100"
        return jsonify({"success": True, "data": _read_query(sql, params)})
    except Exception:
        return _error("Unable to load transport providers", 503)
