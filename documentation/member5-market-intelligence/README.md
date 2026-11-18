# AgriSphere AI — Member 5: Market Intelligence

## Scope
This module implements the Member 5 responsibilities from the team distribution plan: Marketplace, Buyer/Seller directory, price reference, nearby market directory, cold-storage directory and transport-provider directory. It owns only `mi_*` MySQL tables and does not edit Member 4 files.

## Confirmed stack from the supplied Member 4 module
- Frontend: HTML, CSS, vanilla JavaScript
- Backend: Python, Flask, Flask-CORS
- Database: MySQL (`mysql-connector-python`)

## Files
- `frontend/market-intelligence/index.html` — module dashboard
- `frontend/market-intelligence/css/style.css` — responsive styling
- `frontend/market-intelligence/js/app.js` — API integration
- `backend/market_intelligence/db.py` — MySQL connection helper (same `.env` variable convention as Member 4)
- `backend/market_intelligence/routes/market_intelligence.py` — Flask blueprint and API routes
- `database/member5/market_intelligence.sql` — isolated schema

## Database setup
1. Create/use the same MySQL database configured by the project's root `.env`.
2. Run `database/member5/market_intelligence.sql` in that database.
3. Ensure the root `.env` contains `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, and `DB_NAME`. Never commit `.env`.
4. Add real, verified market, seller, price, storage and transport records. Empty tables intentionally show empty states; the module does not fabricate live listings.

## Backend setup and integration
The supplied ZIP contains Member 4's Flask route modules but does not include the root Flask application/entrypoint. Therefore the blueprint registration below is an integration instruction, not an edit to a guessed app file.

1. Install the existing backend requirements (the Member 4 requirements include Flask, Flask-CORS, mysql-connector-python and python-dotenv).
2. Copy `backend/market_intelligence/db.py` into the Python import path used by the route, or adjust the import consistently with the actual root app layout.
3. Register the blueprint in the existing Flask app after importing it:

```python
from market_intelligence.routes.market_intelligence import market_bp
app.register_blueprint(market_bp)
```

If the project uses package imports, use the corresponding package-qualified import. Keep the route module's `db` import aligned with the actual app's shared DB helper. Do not register a second Flask application.

## API endpoints
| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/api/market-intelligence/health` | API/database health check |
| GET | `/api/market-intelligence/markets?city=` | Search market directory |
| GET | `/api/market-intelligence/listings?crop=&city=` | Browse available crop listings |
| POST | `/api/market-intelligence/listings` | Create listing for an existing seller |
| GET | `/api/market-intelligence/buyers-sellers?role=` | Browse buyer/seller directory |
| GET | `/api/market-intelligence/price-prediction/<crop>` | Historical-average reference from latest 6 records |
| GET | `/api/market-intelligence/cold-storage?city=` | Find storage with available capacity |
| GET | `/api/market-intelligence/transport?city=` | Find transport providers |

### Create listing body
```json
{
  "seller_id": 1,
  "crop_name": "Wheat",
  "variety": "Lokwan",
  "quantity_kg": 500,
  "price_per_kg": 24.5,
  "quality_grade": "A",
  "description": "Harvested this week"
}
```
The seller must already exist in `mi_buyers_sellers` with role `seller` or `both`.

## Price reference limitation
The current price endpoint calculates the arithmetic mean of up to six latest stored modal-price observations. It is deliberately described as a historical-average reference, **not an ML prediction**. A genuine predictive model requires a verified historical dataset, model training/evaluation and a separate deployment plan.

## Frontend run
Serve the `frontend/market-intelligence` folder through the project's existing static-file/web server. If the frontend and API are on different origins, configure Flask-CORS in the root Flask app for the exact frontend origin. If API is hosted at a non-root URL, define `window.AGRISPHERE_API_BASE` before `js/app.js` (for example, `/backend` only if that is the real deployment prefix).

## Integration notes / outstanding items
- This ZIP did not contain the root Flask entrypoint, global frontend router, global DB helper, authentication middleware or root dependency manifest. Blueprint registration and final import paths must be checked against those files before merge.
- Current listing creation accepts a seller ID and is not yet connected to the platform's login/session identity. Add the existing project's authentication/authorization middleware before production use.
- No real location coordinates or map provider were present in the supplied code; nearby market search currently filters the directory by city/state, rather than GPS distance.
- Populate directory and price tables only with verified data and include source/date for price observations.
- Do not commit credentials or `.env`.
