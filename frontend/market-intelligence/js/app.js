/* Member 5 Market Intelligence frontend. Set window.AGRISPHERE_API_BASE before this script if needed. */
(() => {
  const API_BASE = (window.AGRISPHERE_API_BASE || '').replace(/\/$/, '') + '/api/market-intelligence';
  const $ = (id) => document.getElementById(id);
  const notice = $('notice');
  const esc = (value) => String(value ?? '').replace(/[&<>"']/g, ch => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[ch]));
  const money = (value) => new Intl.NumberFormat('en-IN',{style:'currency',currency:'INR',maximumFractionDigits:2}).format(Number(value || 0));
  function showError(target, message) { if (target) target.innerHTML = `<div class="empty-state">${esc(message)}</div>`; }
  async function api(path, options={}) {
    const response = await fetch(`${API_BASE}${path}`, {headers:{'Content-Type':'application/json',...(options.headers||{})}, ...options});
    const payload = await response.json().catch(() => ({}));
    if (!response.ok || payload.success === false) throw new Error(payload.message || `Request failed (${response.status})`);
    return payload;
  }
  function renderListings(items) {
    const target=$('listings'); if(!items.length){showError(target,'No crop listings found. Try another crop or location.');return;}
    target.innerHTML=items.map(item=>`<article class="data-card"><div class="card-top"><span class="crop-chip">${esc(item.quality_grade || 'Standard')} quality</span><span class="subtle">#${esc(item.id)}</span></div><h3>${esc(item.crop_name)}${item.variety?` · ${esc(item.variety)}`:''}</h3><p class="subtle">Seller: ${esc(item.seller_name)} · ${esc(item.city || '')}${item.state?`, ${esc(item.state)}`:''}</p><div class="price">${money(item.price_per_kg)} <span class="subtle">/ kg</span></div><p class="subtle">Available quantity: ${esc(item.quantity_kg)} kg</p><div class="card-meta"><span>☎ ${esc(item.seller_phone || 'Contact not listed')}</span><span>${esc(item.description || 'Direct seller listing')}</span></div></article>`).join('');
  }
  async function loadListings(crop='',city='') { const target=$('listings'); target.innerHTML='<div class="empty-state">Loading crop listings…</div>'; try{const q=new URLSearchParams();if(crop)q.set('crop',crop);if(city)q.set('city',city);const data=await api(`/listings?${q}`);renderListings(data.data||[]);}catch(e){showError(target,e.message);}}
  async function loadMarkets(city='') { const target=$('marketsList'); target.innerHTML='<div class="empty-state">Loading markets…</div>';try{const q=new URLSearchParams();if(city)q.set('city',city);const data=await api(`/markets?${q}`);const items=data.data||[];target.innerHTML=items.length?items.map(x=>`<article class="list-card"><div class="list-icon">⌖</div><div><h3>${esc(x.name)}</h3><p>${esc([x.address,x.city,x.state].filter(Boolean).join(', '))}</p><p>${esc(x.market_type||'Agricultural market')} · ${esc(x.opening_time||'Hours not listed')} – ${esc(x.closing_time||'')}</p></div></article>`).join(''):'<div class="empty-state">No markets found for this location.</div>';}catch(e){showError(target,e.message);}}
  async function loadLogistics(city='') { for(const [endpoint,id,icon,title] of [['cold-storage','storageList','▣',''],['transport','transportList','⇢','']]){const target=$(id);target.textContent='Loading…';try{const q=new URLSearchParams();if(city)q.set('city',city);const data=await api(`/${endpoint}?${q}`);const items=data.data||[];target.innerHTML=items.length?items.map(x=>{const name=x.name||x.provider_name;const detail=endpoint==='cold-storage'?`Available: ${esc(x.available_capacity_tonnes)} / ${esc(x.capacity_tonnes)} tonnes · ${x.price_per_tonne_day?money(x.price_per_tonne_day)+' / tonne / day':'Rate not listed'}`:`${esc(x.vehicle_type)} · Capacity: ${esc(x.load_capacity_tonnes)} tonnes · ${x.price_per_km?money(x.price_per_km)+' / km':'Rate not listed'}`;return `<article class="list-card"><div class="list-icon">${icon}</div><div><h3>${esc(name)}</h3><p>${esc([x.city,x.state,x.address||x.service_area].filter(Boolean).join(', '))}</p><p>${detail}</p><p>☎ ${esc(x.contact_phone||'Contact not listed')}</p></div></article>`;}).join(''):'<div class="empty-state">No records found for this location.</div>';}catch(e){showError(target,e.message);}}}
  $('listingFilters').addEventListener('submit',e=>{e.preventDefault();loadListings($('cropFilter').value.trim(),$('cityFilter').value.trim());});
  $('marketForm').addEventListener('submit',e=>{e.preventDefault();loadMarkets($('marketCity').value.trim());});
  $('logisticsForm').addEventListener('submit',e=>{e.preventDefault();loadLogistics($('logisticsCity').value.trim());});
  $('priceForm').addEventListener('submit',async e=>{e.preventDefault();const crop=$('priceCrop').value.trim();const target=$('priceResult');target.textContent='Checking historical price observations…';try{const data=await api(`/price-prediction/${encodeURIComponent(crop)}`);target.innerHTML=`<p><strong>${esc(data.crop)}</strong> · ${esc(data.observations)} historical observations</p><div class="price">${money(data.estimated_reference_price)} <span class="subtle">per kg</span></div><p>${esc(data.method)}. ${esc(data.disclaimer)}</p>`;}catch(err){target.textContent=err.message;}});
  api('/health').then(()=>{notice.textContent='Market Intelligence API connected.';}).catch(()=>{notice.textContent='API not connected yet. Start the Flask backend and configure MySQL to load live records.';notice.classList.add('error');});
  loadListings();loadMarkets();loadLogistics();
})();
