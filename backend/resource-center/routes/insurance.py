from flask import Blueprint, jsonify, request
from db import get_db_connection


insurance_bp = Blueprint(
    "insurance",
    __name__,
    url_prefix="/api/resource/insurance"
)


# GET ALL INSURANCE OPTIONS
@insurance_bp.route("", methods=["GET"])
def get_insurance():

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM insurance
        ORDER BY id DESC
    """)

    insurance_options = cursor.fetchall()

    cursor.close()
    connection.close()

    return jsonify(insurance_options)


# GET INSURANCE BY ID
@insurance_bp.route("/<int:insurance_id>", methods=["GET"])
def get_insurance_by_id(insurance_id):

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM insurance WHERE id = %s",
        (insurance_id,)
    )

    insurance = cursor.fetchone()

    cursor.close()
    connection.close()

    if insurance is None:
        return jsonify({
            "message": "Insurance option not found"
        }), 404

    return jsonify(insurance)

    # CREATE INSURANCE REQUEST
@insurance_bp.route("/<int:insurance_id>/request", methods=["POST"])
def create_insurance_request(insurance_id):

    data = request.get_json()

    customer_name = data.get("customer_name")
    customer_phone = data.get("customer_phone")
    location = data.get("location")
    remarks = data.get("remarks")


    # Validate required fields
    if not customer_name or not customer_phone or not location:

        return jsonify({
            "message": "Name, phone number and location are required"
        }), 400


    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)


    # Check whether insurance option exists
    cursor.execute(
        "SELECT * FROM insurance WHERE id = %s",
        (insurance_id,)
    )

    insurance = cursor.fetchone()


    if insurance is None:

        cursor.close()
        connection.close()

        return jsonify({
            "message": "Insurance option not found"
        }), 404


    # Insert request
    cursor.execute("""
        INSERT INTO insurance_requests
        (
            insurance_id,
            customer_name,
            customer_phone,
            location,
            remarks
        )
        VALUES (%s, %s, %s, %s, %s)
    """, (
        insurance_id,
        customer_name,
        customer_phone,
        location,
        remarks
    ))


    connection.commit()

    request_id = cursor.lastrowid


    cursor.close()
    connection.close()


    return jsonify({
        "message": "Insurance assistance request submitted successfully",
        "request_id": request_id,
        "insurance": insurance["name"],
        "status": "Pending"
    }), 201
