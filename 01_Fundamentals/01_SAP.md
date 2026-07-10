# SAP

## Latar Belakang

Perusahaan berskala besar mengelola ribuan aset, transaksi, dan aktivitas operasional setiap hari. Setiap divisi memiliki kebutuhan yang berbeda, seperti pengelolaan produksi, pembelian, pemeliharaan aset, keuangan, hingga sumber daya manusia.

Apabila setiap divisi menggunakan aplikasi yang berbeda tanpa integrasi, data akan tersebar pada banyak sistem sehingga sulit dijaga konsistensinya.

SAP hadir sebagai Enterprise Resource Planning (ERP) yang mengintegrasikan seluruh proses bisnis perusahaan ke dalam satu sistem.
---

# Tujuan

SAP bertujuan mengintegrasikan proses bisnis sehingga seluruh departemen menggunakan sumber data yang sama.

Dengan demikian.

- Data lebih konsisten.
- Proses bisnis menjadi terstandarisasi.
- Informasi dapat dibagikan antar departemen secara real-time.

---

# Apa itu ERP?

Enterprise Resource Planning (ERP) adalah sistem yang mengintegrasikan berbagai proses bisnis perusahaan dalam satu platform.

Sebagai contoh.

```text
Pembelian Material
↓
Gudang
↓
Produksi
↓
Maintenance
↓
Keuangan
```

Seluruh proses tersebut saling terhubung.

---

# Modul SAP

SAP terdiri atas berbagai modul sesuai kebutuhan bisnis.

Beberapa modul yang umum digunakan.

| Modul | Fungsi |
|--------|--------|
| PM | Plant Maintenance |
| MM | Material Management |
| SD | Sales and Distribution |
| FI | Financial Accounting |
| CO | Controlling |
| PP | Production Planning |
| HR | Human Resources |

Setiap modul menangani proses bisnis yang berbeda tetapi tetap menggunakan database yang sama.

---

# SAP PM

Pada kegiatan maintenance, modul yang paling sering digunakan adalah SAP Plant Maintenance (PM).

SAP PM digunakan untuk mengelola.

- Equipment
- Functional Location
- Notification
- Work Order
- Preventive Maintenance
- Breakdown Maintenance
- History Maintenance

---

# Arsitektur SAP

Secara sederhana.

```text
User
↓
SAP GUI / Fiori
↓
Application Server
↓
ABAP Program
↓
Database
```

User tidak berinteraksi langsung dengan database.

Semua proses dijalankan oleh ABAP.

---

# Mengapa Membutuhkan ABAP?

SAP menyediakan banyak fungsi standar.

Namun setiap perusahaan memiliki business rule yang berbeda.

Contohnya.

```
Permit harus diisi.
Running Hour > 6000.
Motor harus berada pada Plant tertentu.
```

Business rule tersebut tidak selalu tersedia pada SAP standar.

ABAP digunakan untuk menambahkan logika sesuai kebutuhan perusahaan.

---

# Ringkasan

- SAP merupakan ERP yang mengintegrasikan proses bisnis perusahaan.
- SAP terdiri atas berbagai modul sesuai fungsi bisnis.
- SAP PM digunakan untuk aktivitas maintenance.
- User berinteraksi dengan SAP melalui aplikasi, sedangkan seluruh logika dijalankan oleh ABAP.
- ABAP digunakan untuk menyesuaikan SAP dengan kebutuhan bisnis perusahaan.