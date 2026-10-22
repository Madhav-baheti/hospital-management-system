// MediCare Plus — Hospital ERP Frontend Controller

let currentSelectedEntity = 'patient';

document.addEventListener('DOMContentLoaded', () => {
  loadERPStats();
  populateDropdowns();
  loadDrawerData();
  selectEntityForm('patient');
});

// =============================================================================
// STATS & METRICS
// =============================================================================
async function loadERPStats() {
  try {
    const res = await fetch('/api/dashboard/stats');
    const data = await res.json();

    if (data.patients_today) {
      document.getElementById('card-patient-adm').textContent = 
        String(data.patients_today.admission).padStart(2, '0');
      document.getElementById('card-patient-treatment').textContent = 
        String(data.patients_today.under_treatment).padStart(2, '0');
      document.getElementById('card-patient-discharge').textContent = 
        String(data.patients_today.discharge).padStart(2, '0');
    }

    if (data.expense_today) {
      document.getElementById('card-expense-today').textContent = 
        Number(data.expense_today.today).toFixed(2);
      document.getElementById('card-expense-month').textContent = 
        Number(data.expense_today.this_month).toFixed(2);
    }

    if (data.collection_today) {
      document.getElementById('card-coll-clinic').textContent = 
        Number(data.collection_today.clinic).toFixed(2);
      document.getElementById('card-coll-lab').textContent = 
        Number(data.collection_today.lab).toFixed(2);
      document.getElementById('card-coll-total').textContent = 
        Number(data.collection_today.total).toFixed(2);
    }

    if (data.due_not_collected) {
      document.getElementById('card-due-clinic').textContent = 
        Number(data.due_not_collected.clinic).toFixed(2);
      document.getElementById('card-due-lab').textContent = 
        Number(data.due_not_collected.lab).toFixed(2);
      document.getElementById('card-due-total').textContent = 
        Number(data.due_not_collected.total).toFixed(2);
    }

    if (data.lab_reports_today) {
      document.getElementById('card-lab-pending').textContent = 
        String(data.lab_reports_today.pending).padStart(2, '0');
      document.getElementById('card-lab-samples').textContent = 
        String(data.lab_reports_today.sample_collection).padStart(2, '0');
      document.getElementById('card-lab-delivered').textContent = 
        String(data.lab_reports_today.delivered).padStart(2, '0');
    }

    if (data.available_bed) {
      document.getElementById('card-bed-available').textContent = 
        String(data.available_bed.available).padStart(2, '0');
    }
  } catch (err) {
    console.error("Error fetching ERP stats:", err);
  }
}

// =============================================================================
// NAVIGATION & DRAWERS
// =============================================================================
function activateNav(buttonEl, navKey) {
  document.querySelectorAll('.dock-pill').forEach(btn => btn.classList.remove('active'));
  buttonEl.classList.add('active');

  if (navKey === 'outdoor') {
    openDrawer('drawer-outdoor');
  } else if (navKey === 'lab') {
    openDrawer('drawer-lab');
  } else if (navKey === 'prescription') {
    openModal('modal-book-appt');
  } else if (navKey === 'users') {
    openDrawer('drawer-users');
  } else if (navKey === 'master') {
    openDrawer('drawer-admissions');
  }
}

function openDrawer(drawerId) {
  closeAllDrawers();
  const drawer = document.getElementById(drawerId);
  const overlay = document.getElementById('drawer-overlay');
  if (drawer && overlay) {
    drawer.classList.add('active');
    overlay.classList.add('active');
  }
}

function closeAllDrawers() {
  document.querySelectorAll('.slide-drawer').forEach(d => d.classList.remove('active'));
  const overlay = document.getElementById('drawer-overlay');
  if (overlay) overlay.classList.remove('active');
}

// =============================================================================
// INLINE PATIENT REGISTRATION TOGGLE (APPOINTMENT & ADMISSION)
// =============================================================================
function togglePatientMode(prefix, mode) {
  const existingGroup = document.getElementById(`${prefix}-existing-patient-group`);
  const newGroup = document.getElementById(`${prefix}-new-patient-group`);
  
  document.querySelectorAll(`.patient-mode-toggle .radio-pill`).forEach(p => {
    if (p.getAttribute('onclick').includes(prefix)) {
      p.classList.toggle('active', p.getAttribute('onclick').includes(mode));
    }
  });

  if (mode === 'existing') {
    if (existingGroup) existingGroup.style.display = 'flex';
    if (newGroup) newGroup.style.display = 'none';
  } else {
    if (existingGroup) existingGroup.style.display = 'none';
    if (newGroup) newGroup.style.display = 'flex';
  }
}

// =============================================================================
// DYNAMIC UNIVERSAL "+ NEW ENTRY" FORM BUILDER
// =============================================================================
function openUniversalNewModal() {
  openModal('modal-universal-new');
  selectEntityForm(currentSelectedEntity);
}

// ROOM CATEGORY TO DAILY RATE AUTOMATION
function handleRoomTypeChange(roomType) {
  const chargeInput = document.getElementById('dynamic-daily-charge');
  if (!chargeInput) return;

  const defaultRates = {
    'General Ward': 1200,
    'Semi-Private': 2500,
    'Private Deluxe': 4500,
    'ICU': 7500,
    'CCU': 8500
  };

  if (defaultRates[roomType] !== undefined) {
    chargeInput.value = defaultRates[roomType];
  }
}

function selectEntityForm(entity, chipEl) {
  currentSelectedEntity = entity;
  
  if (chipEl) {
    document.querySelectorAll('.entity-chip').forEach(c => c.classList.remove('active'));
    chipEl.classList.add('active');
  }

  const container = document.getElementById('dynamic-fields-container');
  if (!container) return;

  if (entity === 'patient') {
    container.innerHTML = `
      <div class="form-row">
        <div class="form-group col">
          <label>Full Patient Name *:</label>
          <input type="text" name="name" required placeholder="e.g. Ramesh Varma">
        </div>
        <div class="form-group col">
          <label>Gender:</label>
          <select name="gender">
            <option value="Male">Male</option>
            <option value="Female">Female</option>
            <option value="Other">Other</option>
          </select>
        </div>
      </div>
      <div class="form-row">
        <div class="form-group col">
          <label>Date of Birth:</label>
          <input type="date" name="dob" value="1995-05-15">
        </div>
        <div class="form-group col">
          <label>Blood Group:</label>
          <select name="blood_group">
            <option value="O+">O+</option>
            <option value="A+">A+</option>
            <option value="B+">B+</option>
            <option value="AB+">AB+</option>
            <option value="O-">O-</option>
          </select>
        </div>
      </div>
      <div class="form-row">
        <div class="form-group col">
          <label>Phone Number (Unique) *:</label>
          <input type="tel" name="phone" required placeholder="98XXXXXXXX">
        </div>
        <div class="form-group col">
          <label>Email Address:</label>
          <input type="email" name="email" placeholder="patient@gmail.com">
        </div>
      </div>
      <div class="form-group">
        <label>Residential Address:</label>
        <input type="text" name="address" placeholder="Flat No, Colony, City">
      </div>
      <div class="form-group">
        <label>Known Allergies:</label>
        <input type="text" name="allergies" placeholder="e.g. Penicillin, Aspirin (or 'None')">
      </div>
    `;
  } else if (entity === 'doctor') {
    container.innerHTML = `
      <div class="form-row">
        <div class="form-group col">
          <label>Doctor Full Name *:</label>
          <input type="text" name="name" required placeholder="e.g. Dr. Anand Verma">
        </div>
        <div class="form-group col">
          <label>Qualifications:</label>
          <input type="text" name="qualification" placeholder="e.g. MBBS, MD, DM">
        </div>
      </div>
      <div class="form-row">
        <div class="form-group col">
          <label>Specialization *:</label>
          <input type="text" name="specialization" required placeholder="e.g. Interventional Cardiologist">
        </div>
        <div class="form-group col">
          <label>Department:</label>
          <select name="dept_id" id="dynamic-dept-select"></select>
        </div>
      </div>
      <div class="form-row">
        <div class="form-group col">
          <label>Contact Phone:</label>
          <input type="tel" name="phone" required placeholder="98XXXXXXXX">
        </div>
        <div class="form-group col">
          <label>Email Address:</label>
          <input type="email" name="email" placeholder="doctor@hospital.org">
        </div>
      </div>
    `;
    populateDynamicDepts();
  } else if (entity === 'room') {
    container.innerHTML = `
      <div class="form-row">
        <div class="form-group col">
          <label>Room Number / Bed Code *:</label>
          <input type="text" name="room_no" required placeholder="e.g. ICU-103 or DLX-203">
        </div>
        <div class="form-group col">
          <label>Room Category:</label>
          <select name="room_type" id="dynamic-room-type" onchange="handleRoomTypeChange(this.value)">
            <option value="General Ward" selected>General Ward</option>
            <option value="Semi-Private">Semi-Private</option>
            <option value="Private Deluxe">Private Deluxe</option>
            <option value="ICU">ICU (Intensive Care)</option>
            <option value="CCU">CCU (Cardiac Care)</option>
          </select>
        </div>
      </div>
      <div class="form-row">
        <div class="form-group col">
          <label>Floor Number:</label>
          <input type="number" name="floor" value="1" min="1" max="10">
        </div>
        <div class="form-group col">
          <label>Daily Rate (INR) *:</label>
          <input type="number" name="daily_charge" id="dynamic-daily-charge" value="1200" step="100">
        </div>
      </div>
    `;
  } else if (entity === 'department') {
    container.innerHTML = `
      <div class="form-group">
        <label>Department Name *:</label>
        <input type="text" name="name" required placeholder="e.g. Endocrinology & Metabolism">
      </div>
      <div class="form-row">
        <div class="form-group col">
          <label>Location / Wing:</label>
          <input type="text" name="location" placeholder="e.g. Block C, 2nd Floor">
        </div>
        <div class="form-group col">
          <label>Extension / Phone:</label>
          <input type="tel" name="phone" placeholder="040-XXXXXXX">
        </div>
      </div>
    `;
  } else if (entity === 'appointment') {
    container.innerHTML = `
      <div class="form-group">
        <label>Patient:</label>
        <select name="patient_id" id="dynamic-patient-select" required></select>
      </div>
      <div class="form-group">
        <label>Consulting Doctor:</label>
        <select name="doctor_id" id="dynamic-doctor-select" required></select>
      </div>
      <div class="form-row">
        <div class="form-group col">
          <label>Date:</label>
          <input type="date" name="appointment_date" value="${new Date().toISOString().split('T')[0]}" required>
        </div>
        <div class="form-group col">
          <label>Time:</label>
          <input type="time" name="appointment_time" value="11:00" required>
        </div>
      </div>
      <div class="form-group">
        <label>Reason / Clinical Symptoms:</label>
        <input type="text" name="reason" placeholder="e.g. Chest pain assessment" required>
      </div>
    `;
    populateDynamicPatientsAndDoctors();
  } else if (entity === 'admission') {
    container.innerHTML = `
      <div class="form-group">
        <label>Patient:</label>
        <select name="patient_id" id="dynamic-patient-select" required></select>
      </div>
      <div class="form-group">
        <label>Attending Doctor:</label>
        <select name="doctor_id" id="dynamic-doctor-select" required></select>
      </div>
      <div class="form-group">
        <label>Select Room / Bed:</label>
        <select name="room_id" id="dynamic-room-select" required></select>
      </div>
      <div class="form-group">
        <label>Admitting Diagnosis:</label>
        <input type="text" name="diagnosis" placeholder="e.g. Unstable Angina observation" required>
      </div>
    `;
    populateDynamicPatientsAndDoctorsAndRooms();
  } else if (entity === 'labtest') {
    container.innerHTML = `
      <div class="form-group">
        <label>Patient:</label>
        <select name="patient_id" id="dynamic-patient-select" required></select>
      </div>
      <div class="form-group">
        <label>Doctor:</label>
        <select name="doctor_id" id="dynamic-doctor-select" required></select>
      </div>
      <div class="form-row">
        <div class="form-group col">
          <label>Lab Investigation:</label>
          <select name="test_id" id="dynamic-test-select" required></select>
        </div>
        <div class="form-group col">
          <label>Status:</label>
          <select name="status">
            <option value="Pending">Pending</option>
            <option value="Completed">Completed</option>
            <option value="Reviewed">Reviewed</option>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label>Diagnostic Findings / Result:</label>
        <textarea name="result" rows="2" placeholder="e.g. Serum Troponin-I: 0.02 ng/mL (Normal)"></textarea>
      </div>
      <div class="form-group">
        <label>Clinical Remarks:</label>
        <input type="text" name="remarks" placeholder="e.g. Report normal, routine review">
      </div>
    `;
    populateDynamicLabSelects();
  }
}

// DYNAMIC SELECT POPULATORS
async function populateDynamicDepts() {
  try {
    const res = await fetch('/api/departments');
    const depts = await res.json();
    const sel = document.getElementById('dynamic-dept-select');
    if (sel) {
      sel.innerHTML = depts.map(d => `<option value="${d.Dept_id}">${d.Dept_name}</option>`).join('');
    }
  } catch (e) {}
}

async function populateDynamicPatientsAndDoctors() {
  try {
    const resP = await fetch('/api/patients');
    const patients = await resP.json();
    const selP = document.getElementById('dynamic-patient-select');
    if (selP) selP.innerHTML = patients.map(p => `<option value="${p.Patient_id}">${p.Patient_name} (${p.Phone})</option>`).join('');

    const resD = await fetch('/api/doctors');
    const doctors = await resD.json();
    const selD = document.getElementById('dynamic-doctor-select');
    if (selD) selD.innerHTML = doctors.map(d => `<option value="${d.Doctor_id}">${d.Doctor_name} (${d.Specialization})</option>`).join('');
  } catch (e) {}
}

async function populateDynamicPatientsAndDoctorsAndRooms() {
  await populateDynamicPatientsAndDoctors();
  try {
    const resR = await fetch('/api/rooms');
    const rooms = await resR.json();
    const avail = rooms.filter(r => r.Status === 'Available');
    const selR = document.getElementById('dynamic-room-select');
    if (selR) selR.innerHTML = avail.map(r => `<option value="${r.Room_id}">${r.Room_no} - ${r.Room_type} (₹${r.Daily_charge}/day)</option>`).join('');
  } catch (e) {}
}

async function populateDynamicLabSelects() {
  await populateDynamicPatientsAndDoctors();
  try {
    const resT = await fetch('/api/lab-tests');
    const data = await resT.json();
    const selT = document.getElementById('dynamic-test-select');
    if (selT) selT.innerHTML = (data.tests || []).map(t => `<option value="${t.Test_id}">${t.Test_name} (${t.Test_type})</option>`).join('');
  } catch (e) {}
}

// HANDLE DYNAMIC UNIVERSAL FORM SUBMISSION
async function handleUniversalFormSubmit(e) {
  e.preventDefault();
  const form = e.target;
  const formData = new FormData(form);
  const payload = Object.fromEntries(formData.entries());

  let targetUrl = '';
  if (currentSelectedEntity === 'patient') targetUrl = '/api/patients';
  else if (currentSelectedEntity === 'doctor') targetUrl = '/api/doctors';
  else if (currentSelectedEntity === 'room') targetUrl = '/api/rooms';
  else if (currentSelectedEntity === 'department') targetUrl = '/api/departments';
  else if (currentSelectedEntity === 'appointment') {
    targetUrl = '/api/appointments';
    payload.appointment_time = (payload.appointment_time || '10:00') + ':00';
  } else if (currentSelectedEntity === 'admission') targetUrl = '/api/admissions';
  else if (currentSelectedEntity === 'labtest') targetUrl = '/api/lab-tests/result';

  try {
    const res = await fetch(targetUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    const result = await res.json();

    if (result.success) {
      alert(`✅ Success: ${result.message}`);
      closeModal('modal-universal-new');
      loadERPStats();
      populateDropdowns();
      loadDrawerData();
    } else {
      alert(`⚠️ Database Error / Constraint Violation:\n\n${result.error}`);
    }
  } catch (err) {
    alert("Network error: " + err.message);
  }
}

// =============================================================================
// BOOK APPOINTMENT (SUPPORTS INLINE NEW PATIENT ENTRY)
// =============================================================================
async function handleBookAppt(e) {
  e.preventDefault();
  const isNew = document.querySelector('input[name="appt_pat_mode"]:checked').value === 'new';
  
  let payload = {
    doctor_id: document.getElementById('appt-doctor-select').value,
    appointment_date: document.getElementById('appt-date').value,
    appointment_time: document.getElementById('appt-time').value + ':00',
    reason: document.getElementById('appt-reason').value
  };

  if (isNew) {
    payload.is_new_patient = true;
    payload.new_patient_name = document.getElementById('appt-new-name').value;
    payload.new_patient_phone = document.getElementById('appt-new-phone').value;
    payload.new_patient_gender = document.getElementById('appt-new-gender').value;
    payload.new_patient_blood = document.getElementById('appt-new-blood').value;
  } else {
    payload.patient_id = document.getElementById('appt-patient-select').value;
  }

  try {
    const res = await fetch('/api/appointments', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    const result = await res.json();

    if (result.success) {
      alert("✅ " + result.message);
      closeModal('modal-book-appt');
      loadERPStats();
      populateDropdowns();
      loadDrawerData();
    } else {
      alert("⚠️ Database Trigger / Constraint Alert:\n" + result.error);
    }
  } catch (err) {
    alert("Network error: " + err.message);
  }
}

// =============================================================================
// ADMIT PATIENT (SUPPORTS INLINE NEW PATIENT ENTRY)
// =============================================================================
async function handleAdmitPatient(e) {
  e.preventDefault();
  const isNew = document.querySelector('input[name="admit_pat_mode"]:checked').value === 'new';

  let payload = {
    doctor_id: document.getElementById('admit-doctor-select').value,
    room_id: document.getElementById('admit-room-select').value,
    diagnosis: document.getElementById('admit-diagnosis').value
  };

  if (isNew) {
    payload.is_new_patient = true;
    payload.new_patient_name = document.getElementById('admit-new-name').value;
    payload.new_patient_phone = document.getElementById('admit-new-phone').value;
    payload.new_patient_gender = document.getElementById('admit-new-gender').value;
    payload.new_patient_blood = document.getElementById('admit-new-blood').value;
  } else {
    payload.patient_id = document.getElementById('admit-patient-select').value;
  }

  try {
    const res = await fetch('/api/admissions', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    const result = await res.json();

    if (result.success) {
      alert("✅ " + result.message);
      closeModal('modal-admit');
      loadERPStats();
      populateDropdowns();
      loadDrawerData();
    } else {
      alert("Error: " + result.error);
    }
  } catch (err) {
    alert("Network error: " + err.message);
  }
}

// =============================================================================
// DRAWERS & SELECT POPULATION
// =============================================================================
async function populateDropdowns() {
  try {
    const resP = await fetch('/api/patients');
    const patients = await resP.json();
    const apptP = document.getElementById('appt-patient-select');
    const admP = document.getElementById('admit-patient-select');
    const pOpts = '<option value="">-- Choose Patient --</option>' + 
      patients.map(p => `<option value="${p.Patient_id}">${p.Patient_name} (${p.Phone})</option>`).join('');
    if (apptP) apptP.innerHTML = pOpts;
    if (admP) admP.innerHTML = pOpts;

    const resD = await fetch('/api/doctors');
    const doctors = await resD.json();
    const apptD = document.getElementById('appt-doctor-select');
    const admD = document.getElementById('admit-doctor-select');
    const dOpts = '<option value="">-- Choose Doctor --</option>' + 
      doctors.map(d => `<option value="${d.Doctor_id}">${d.Doctor_name} (${d.Specialization})</option>`).join('');
    if (apptD) apptD.innerHTML = dOpts;
    if (admD) admD.innerHTML = dOpts;

    const resR = await fetch('/api/rooms');
    const rooms = await resR.json();
    const admR = document.getElementById('admit-room-select');
    const avail = rooms.filter(r => r.Status === 'Available');
    if (admR) {
      admR.innerHTML = '<option value="">-- Choose Room --</option>' + 
        avail.map(r => `<option value="${r.Room_id}">${r.Room_no} - ${r.Room_type} (₹${r.Daily_charge})</option>`).join('');
    }
  } catch (err) {
    console.error(err);
  }
}

async function loadDrawerData() {
  // Outdoor Appointments
  try {
    const resAppt = await fetch('/api/appointments');
    const appts = await resAppt.json();
    const tbodyOutdoor = document.getElementById('tbody-outdoor');
    if (tbodyOutdoor) {
      tbodyOutdoor.innerHTML = appts.map(a => `
        <tr>
          <td><strong>#${a.Appointment_id}</strong></td>
          <td><strong>${a.Patient_name}</strong><br><small class="text-muted">${a.Phone}</small></td>
          <td>${a.Doctor_name}</td>
          <td>${a.Appointment_time.substring(0, 5)}</td>
          <td>${a.Reason || 'General'}</td>
          <td><span style="font-weight:700; color:${a.Status === 'Completed' ? '#059669' : '#2563EB'}">${a.Status}</span></td>
          <td>
            ${a.Status === 'Scheduled' ? `
              <button class="btn-xs btn-primary" onclick="updateApptStatus(${a.Appointment_id}, 'Completed')">Complete</button>
            ` : '—'}
          </td>
        </tr>
      `).join('');
    }
  } catch (e) {}

  // Lab Worklist
  try {
    const resLab = await fetch('/api/lab-tests');
    const dataLab = await resLab.json();
    const tbodyLab = document.getElementById('tbody-lab');
    if (tbodyLab) {
      tbodyLab.innerHTML = (dataLab.results || []).map(r => `
        <tr>
          <td>#${r.Result_id}</td>
          <td><strong>${r.Patient_name}</strong></td>
          <td>${r.Test_name}</td>
          <td>${r.Test_type}</td>
          <td>${r.Result_date}</td>
          <td>${r.Result || '<em class="text-muted">Awaiting analysis</em>'}</td>
          <td><strong style="color:${r.Status === 'Pending' ? '#D97706' : '#059669'}">${r.Status}</strong></td>
        </tr>
      `).join('');
    }
  } catch (e) {}

  // Rooms & Admissions
  try {
    const resRooms = await fetch('/api/rooms');
    const rooms = await resRooms.json();
    const gridRooms = document.getElementById('drawer-rooms-grid');
    if (gridRooms) {
      gridRooms.innerHTML = rooms.map(r => `
        <div class="room-mini-card ${r.Status === 'Available' ? 'avail' : 'occ'}">
          <h5>${r.Room_no}</h5>
          <p>${r.Room_type}</p>
          <p><strong>₹${r.Daily_charge}</strong>/day</p>
          <span style="font-size:10px; font-weight:800; color:${r.Status === 'Available' ? '#059669' : '#DC2626'}">${r.Status.toUpperCase()}</span>
        </div>
      `).join('');
    }

    const resAdm = await fetch('/api/admissions');
    const adms = await resAdm.json();
    const tbodyAdm = document.getElementById('tbody-admissions');
    if (tbodyAdm) {
      tbodyAdm.innerHTML = adms.map(a => `
        <tr>
          <td>#${a.Admission_id}</td>
          <td><strong>${a.Room_no}</strong></td>
          <td>${a.Patient_name}</td>
          <td>${a.Doctor_name || 'Staff'}</td>
          <td>${a.Admission_date}</td>
          <td>${a.Diagnosis}</td>
          <td><strong>${a.Status}</strong></td>
          <td>
            ${a.Status === 'Admitted' ? `
              <button class="btn-xs btn-outline" onclick="dischargePatient(${a.Admission_id}, '${a.Patient_name}')">Discharge</button>
            ` : '—'}
          </td>
        </tr>
      `).join('');
    }
  } catch (e) {}

  // Billing
  try {
    const resBill = await fetch('/api/billing');
    const bills = await resBill.json();
    const tbodyBill = document.getElementById('tbody-billing');
    if (tbodyBill) {
      tbodyBill.innerHTML = bills.map(b => `
        <tr>
          <td>#${b.Bill_id}</td>
          <td><strong>${b.Patient_name}</strong></td>
          <td>${b.Bill_date}</td>
          <td>₹${Number(b.Total_amount).toLocaleString()}</td>
          <td>₹${Number(b.Discount).toLocaleString()}</td>
          <td><strong>₹${Number(b.Net_amount).toLocaleString()}</strong></td>
          <td>₹${Number(b.Total_Paid).toLocaleString()}</td>
          <td><strong style="color:${b.Balance_Due > 0 ? '#DC2626' : '#059669'}">₹${Number(b.Balance_Due).toLocaleString()}</strong></td>
          <td><strong>${b.Status}</strong></td>
        </tr>
      `).join('');
    }
  } catch (e) {}

  // Users / Patients
  try {
    const resPat = await fetch('/api/patients');
    const patients = await resPat.json();
    const tbodyUsers = document.getElementById('tbody-users');
    if (tbodyUsers) {
      tbodyUsers.innerHTML = patients.map(p => `
        <tr>
          <td>#${p.Patient_id}</td>
          <td><strong>${p.Patient_name}</strong></td>
          <td>${p.Gender} (${p.DOB})</td>
          <td>${p.Blood_group || '—'}</td>
          <td>${p.Phone}</td>
          <td><span style="color:#DC2626;">${p.Allergies || 'None'}</span></td>
          <td>${p.Address || '—'}</td>
        </tr>
      `).join('');
    }
  } catch (e) {}
}

async function dischargePatient(admId, patientName) {
  const discountStr = prompt(`Discharge patient ${patientName}?\nEnter discretionary discount in INR (or 0):`, "0");
  if (discountStr === null) return;
  const discount = parseFloat(discountStr) || 0;

  try {
    const res = await fetch(`/api/admissions/${admId}/discharge`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ discount })
    });
    const result = await res.json();
    if (result.success) {
      alert(`Success! ${result.message}\nTotal: ₹${result.total}\nNet Payable: ₹${result.net}`);
      loadERPStats();
      loadDrawerData();
    } else {
      alert("Discharge Error: " + result.error);
    }
  } catch (err) {
    alert("Network error: " + err.message);
  }
}

async function updateApptStatus(apptId, newStatus) {
  try {
    const res = await fetch(`/api/appointments/${apptId}/status`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ status: newStatus })
    });
    const result = await res.json();
    if (result.success) {
      loadERPStats();
      loadDrawerData();
    } else {
      alert("Error: " + result.error);
    }
  } catch (err) {
    alert("Network error: " + err.message);
  }
}

// MODAL CONTROLS
function openModal(modalId) {
  const modal = document.getElementById(modalId);
  if (modal) {
    modal.classList.add('active');
    if (modalId === 'modal-book-appt') {
      document.getElementById('appt-date').value = new Date().toISOString().split('T')[0];
    }
  }
}

function closeModal(modalId) {
  const modal = document.getElementById(modalId);
  if (modal) modal.classList.remove('active');
}

function openSearchModal() {
  openDrawer('drawer-users');
}

// SQL STUDIO CONSOLE
function runPresetQuery(sql) {
  document.getElementById('sql-query-input').value = sql;
  executeCustomSql();
}

async function executeCustomSql() {
  const query = document.getElementById('sql-query-input').value.trim();
  const statusBadge = document.getElementById('sql-status-badge');
  const outputContainer = document.getElementById('sql-result-output');

  if (!query) return;

  statusBadge.textContent = "Executing...";
  const startTime = performance.now();

  try {
    const res = await fetch('/api/sql-console', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ query })
    });
    const duration = (performance.now() - startTime).toFixed(1);
    const data = await res.json();

    if (!data.success) {
      statusBadge.textContent = `Error (${duration}ms)`;
      outputContainer.innerHTML = `<div style="color:#DC2626; font-family:'JetBrains Mono',monospace; font-size:12px;"><strong>Error:</strong> ${data.error}</div>`;
      return;
    }

    statusBadge.textContent = `Success (${duration}ms • ${data.type === 'SELECT' ? data.count + ' rows' : data.rows_affected + ' affected'})`;

    if (data.type === 'SELECT') {
      if (data.rows.length === 0) {
        outputContainer.innerHTML = '<p class="text-muted">Query returned 0 rows.</p>';
        return;
      }

      outputContainer.innerHTML = `
        <table class="erp-table">
          <thead>
            <tr>${data.columns.map(col => `<th>${col}</th>`).join('')}</tr>
          </thead>
          <tbody>
            ${data.rows.map(row => `
              <tr>
                ${data.columns.map(col => `<td>${row[col] !== null ? row[col] : '<em>NULL</em>'}</td>`).join('')}
              </tr>
            `).join('')}
          </tbody>
        </table>
      `;
    } else {
      outputContainer.innerHTML = `<p style="color:#059669; font-weight:700;">${data.message}</p>`;
      loadERPStats();
    }
  } catch (err) {
    statusBadge.textContent = "Failed";
    outputContainer.innerHTML = `<p style="color:#DC2626;">Error: ${err.message}</p>`;
  }
}
