from flask import Blueprint, jsonify, request
from db import get_db_connection

equipment_bp = Blueprint(
    "equipment",
    __name__,
    url_prefix="/api/resource/equipment"
)


# GET ALL EQUIPMENT
@equipment_bp.route("", methods=["GET"])
def get_equipment():

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM equipment
        ORDER BY id DESC
    """)

    equipment = cursor.fetchall()

    cursor.close()
    connection.close()

    return jsonify(equipment)


# GET EQUIPMENT BY ID
@equipment_bp.route("/<int:equipment_id>", methods=["GET"])
def get_equipment_by_id(equipment_id):

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM equipment WHERE id = %s",
        (equipment_id,)
    )

    equipment = cursor.fetchone()

    cursor.close()
    connection.close()

    if equipment is None:
        return jsonify({"message": "Equipment not found"}), 404

    return jsonify(equipment)



    # CREATE RENTAL REQUEST
@equipment_bp.route("/<int:equipment_id>/rent", methods=["POST"])
def create_rental_request(equipment_id):

    data = request.get_json()

    customer_name = data.get("customer_name")
    customer_phone = data.get("customer_phone")
    rental_date = data.get("rental_date")
    number_of_days = data.get("number_of_days")

    if not customer_name or not rental_date or not number_of_days:
        return jsonify({
            "message": "Customer name, rental date and number of days are required"
        }), 400

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    # Check equipment
    cursor.execute(
        "SELECT * FROM equipment WHERE id = %s",
        (equipment_id,)
    )

    equipment = cursor.fetchone()

    if equipment is None:
        cursor.close()
        connection.close()

        return jsonify({
            "message": "Equipment not found"
        }), 404

    # Check availability
    if not equipment["availability"]:
        cursor.close()
        connection.close()

        return jsonify({
            "message": "Equipment is currently not available"
        }), 400

    # Calculate total cost
    total_cost = float(equipment["rent_per_day"]) * int(number_of_days)

    # Insert rental request
    cursor.execute("""
        INSERT INTO rental_requests
        (
            equipment_id,
            customer_name,
            customer_phone,
            rental_date,
            number_of_days,
            total_cost
        )
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (
        equipment_id,
        customer_name,
        customer_phone,
        rental_date,
        number_of_days,
        total_cost
    ))

    connection.commit()

    rental_request_id = cursor.lastrowid

    cursor.close()
    connection.close()

    return jsonify({
        "message": "Rental request submitted successfully",
        "rental_request_id": rental_request_id,
        "equipment": equipment["name"],
        "total_cost": total_cost,
        "status": "Pending"
    }), 201