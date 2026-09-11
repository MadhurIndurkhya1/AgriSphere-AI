from flask import Blueprint, jsonify, request
from db import get_db_connection

loans_bp = Blueprint(
    "loans",
    __name__,
    url_prefix="/api/resource/loans"
)


# GET ALL LOANS
@loans_bp.route("", methods=["GET"])
def get_loans():

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM loans
        ORDER BY id DESC
    """)

    loans = cursor.fetchall()

    cursor.close()
    connection.close()

    return jsonify(loans)


# GET LOAN BY ID
@loans_bp.route("/<int:loan_id>", methods=["GET"])
def get_loan_by_id(loan_id):

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM loans WHERE id = %s",
        (loan_id,)
    )

    loan = cursor.fetchone()

    cursor.close()
    connection.close()

    if loan is None:
        return jsonify({
            "message": "Loan not found"
        }), 404

    return jsonify(loan)

    # CREATE LOAN REQUEST
@loans_bp.route("/<int:loan_id>/request", methods=["POST"])
def create_loan_request(loan_id):

    data = request.get_json()

    customer_name = data.get("customer_name")
    customer_phone = data.get("customer_phone")
    location = data.get("location")
    remarks = data.get("remarks")

    if not customer_name or not customer_phone or not location:
        return jsonify({
            "message": "Name, phone number and location are required"
        }), 400

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM loans WHERE id = %s",
        (loan_id,)
    )

    loan = cursor.fetchone()

    if loan is None:
        cursor.close()
        connection.close()

        return jsonify({
            "message": "Loan not found"
        }), 404

    cursor.execute("""
        INSERT INTO loan_requests
        (
            loan_id,
            customer_name,
            customer_phone,
            location,
            remarks
        )
        VALUES (%s, %s, %s, %s, %s)
    """, (
        loan_id,
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
        "message": "Loan assistance request submitted successfully",
        "request_id": request_id,
        "loan": loan["name"],
        "status": "Pending"
    }), 201