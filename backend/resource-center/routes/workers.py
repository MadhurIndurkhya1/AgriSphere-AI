from flask import Blueprint, jsonify, request
from db import get_db_connection


workers_bp = Blueprint(
    "workers",
    __name__,
    url_prefix="/api/resource/workers"
)


# GET ALL WORKERS
@workers_bp.route("", methods=["GET"])
def get_workers():

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM workers
        ORDER BY id DESC
    """)

    workers = cursor.fetchall()

    cursor.close()
    connection.close()

    return jsonify(workers)


# GET WORKER BY ID
@workers_bp.route("/<int:worker_id>", methods=["GET"])
def get_worker_by_id(worker_id):

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM workers WHERE id = %s",
        (worker_id,)
    )

    worker = cursor.fetchone()

    cursor.close()
    connection.close()

    if worker is None:
        return jsonify({"message": "Worker not found"}), 404

    return jsonify(worker)



    # CREATE HIRING REQUEST
@workers_bp.route("/<int:worker_id>/hire", methods=["POST"])
def create_hiring_request(worker_id):

    data = request.get_json()

    customer_name = data.get("customer_name")
    customer_phone = data.get("customer_phone")
    hiring_date = data.get("hiring_date")
    number_of_days = data.get("number_of_days")

    if not customer_name or not hiring_date or not number_of_days:
        return jsonify({
            "message": "Customer name, hiring date and number of days are required"
        }), 400

    try:
        number_of_days = int(number_of_days)

        if number_of_days <= 0:
            return jsonify({
                "message": "Number of days must be greater than 0"
            }), 400

    except (ValueError, TypeError):
        return jsonify({
            "message": "Number of days must be a valid number"
        }), 400

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    # Check worker
    cursor.execute(
        "SELECT * FROM workers WHERE id = %s",
        (worker_id,)
    )

    worker = cursor.fetchone()

    if worker is None:

        cursor.close()
        connection.close()

        return jsonify({
            "message": "Worker not found"
        }), 404

    # Check availability
    if not worker["availability"]:

        cursor.close()
        connection.close()

        return jsonify({
            "message": "Worker is currently not available"
        }), 400

    # Calculate total cost
    total_cost = float(worker["daily_wage"]) * number_of_days

    # Insert hiring request
    cursor.execute("""
        INSERT INTO hiring_requests
        (
            worker_id,
            customer_name,
            customer_phone,
            hiring_date,
            number_of_days,
            total_cost
        )
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (
        worker_id,
        customer_name,
        customer_phone,
        hiring_date,
        number_of_days,
        total_cost
    ))

    connection.commit()

    hiring_request_id = cursor.lastrowid

    cursor.close()
    connection.close()

    return jsonify({
        "message": "Worker hiring request submitted successfully",
        "hiring_request_id": hiring_request_id,
        "worker": worker["name"],
        "total_cost": total_cost,
        "status": "Pending"
    }), 201