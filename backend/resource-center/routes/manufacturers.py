from flask import Blueprint, jsonify, request
from db import get_db_connection


manufacturers_bp = Blueprint(
    "manufacturers",
    __name__,
    url_prefix="/api/resource/manufacturers"
)


# GET ALL MANUFACTURERS
@manufacturers_bp.route("", methods=["GET"])
def get_manufacturers():

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM manufacturers
        ORDER BY id DESC
    """)

    manufacturers = cursor.fetchall()

    cursor.close()
    connection.close()

    return jsonify(manufacturers)


# GET MANUFACTURER BY ID
@manufacturers_bp.route("/<int:manufacturer_id>", methods=["GET"])
def get_manufacturer_by_id(manufacturer_id):

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM manufacturers WHERE id = %s",
        (manufacturer_id,)
    )

    manufacturer = cursor.fetchone()

    cursor.close()
    connection.close()

    if manufacturer is None:
        return jsonify({"message": "Manufacturer not found"}), 404

    return jsonify(manufacturer)