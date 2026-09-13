from flask import Blueprint, jsonify, request
from db import get_db_connection


schemes_bp = Blueprint(
    "schemes",
    __name__,
    url_prefix="/api/resource/schemes"
)


# GET ALL GOVERNMENT SCHEMES
@schemes_bp.route("", methods=["GET"])
def get_schemes():

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM government_schemes
        ORDER BY id DESC
    """)

    schemes = cursor.fetchall()

    cursor.close()
    connection.close()

    return jsonify(schemes)


# GET GOVERNMENT SCHEME BY ID
@schemes_bp.route("/<int:scheme_id>", methods=["GET"])
def get_scheme_by_id(scheme_id):

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM government_schemes WHERE id = %s",
        (scheme_id,)
    )

    scheme = cursor.fetchone()

    cursor.close()
    connection.close()

    if scheme is None:
        return jsonify({
            "message": "Government scheme not found"
        }), 404

    return jsonify(scheme)

    from flask import request

    # CREATE SCHEME REQUEST
@schemes_bp.route("/<int:scheme_id>/request", methods=["POST"])
def create_scheme_request(scheme_id):

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


    # Check whether scheme exists
    cursor.execute(
        "SELECT * FROM government_schemes WHERE id = %s",
        (scheme_id,)
    )

    scheme = cursor.fetchone()


    if scheme is None:

        cursor.close()
        connection.close()

        return jsonify({
            "message": "Government scheme not found"
        }), 404


    # Insert request
    cursor.execute("""
        INSERT INTO scheme_requests
        (
            scheme_id,
            customer_name,
            customer_phone,
            location,
            remarks
        )
        VALUES (%s, %s, %s, %s, %s)
    """, (
        scheme_id,
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
        "message": "Scheme assistance request submitted successfully",
        "request_id": request_id,
        "scheme": scheme["name"],
        "status": "Pending"
    }), 201