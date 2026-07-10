# ABAP

## Latar Belakang

SAP menyediakan berbagai proses bisnis standar. Namun setiap perusahaan memiliki kebutuhan yang berbeda sehingga diperlukan bahasa pemrograman untuk menambahkan atau menyesuaikan logika bisnis.

Bahasa tersebut adalah **ABAP (Advanced Business Application Programming)**.

ABAP merupakan bahasa pemrograman yang dikembangkan oleh SAP untuk membangun aplikasi, laporan, validasi, maupun otomatisasi proses bisnis di dalam sistem SAP.

---

# Tujuan

ABAP digunakan untuk menerjemahkan business requirement menjadi logika yang dapat dijalankan oleh sistem SAP.

---

# Peran ABAP

ABAP berada di antara User dan Database.

```text
User
↓
SAP
↓
ABAP
↓
Database
```

ABAP bertugas.

- Membaca data.
- Memvalidasi data.
- Menjalankan business rule.
- Menyimpan perubahan.

---

# Contoh

Business Requirement.

```
Motor 6 kV yang TRIP harus dibuatkan Notification.
```

ABAP menerjemahkannya menjadi.

```text
Read Equipment

↓

IF Voltage >= 1000

↓

IF Status = TRIP

↓

Check Notification

↓

Create Notification
```

---

# Jenis Program ABAP

Secara umum ABAP digunakan untuk.

- Report
- Transaction
- Enhancement
- Interface
- Batch Program
- Background Job

Pada SAP PM, yang paling sering ditemui adalah Enhancement dan Report.

---

# Cara Berpikir ABAP

ABAP bukan sekadar bahasa pemrograman.

ABAP merupakan implementasi business process.

Urutan berpikirnya adalah.

```
Business Requirement

↓

Business Rule

↓

ABAP Logic

↓

SAP Transaction
```

Karena itu, sebelum menulis sintaks, programmer harus memahami proses bisnis yang sedang diotomatisasi.

---

# Contoh

Business Requirement.

```
Notification hanya boleh dibuat apabila Permit tersedia.
```

ABAP.

```abap
IF ls_motor-permit IS INITIAL.

    MESSAGE 'Permit Required' TYPE 'E'.

ENDIF.

CALL FUNCTION 'Z_CREATE_NOTIFICATION'.
```

---

# Hubungan dengan SAP

SAP menyediakan platform.

ABAP menjalankan logika bisnis.

Database menyimpan data.

```text
SAP

↓

ABAP

↓

Database
```

Ketiga komponen tersebut bekerja sebagai satu kesatuan.

---

# Ringkasan

- ABAP merupakan bahasa pemrograman SAP.
- ABAP digunakan untuk mengimplementasikan business rule.
- ABAP menghubungkan SAP dengan database.
- Sebelum menulis sintaks, programmer harus memahami proses bisnis yang akan diotomatisasi.