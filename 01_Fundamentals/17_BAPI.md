# BAPI (Business Application Programming Interface)

## Latar Belakang

SAP menyediakan ribuan Function Module yang digunakan oleh berbagai modul, seperti Plant Maintenance (PM), Material Management (MM), Sales and Distribution (SD), dan Finance (FI).

Namun tidak semua Function Module dirancang untuk digunakan secara langsung oleh program lain maupun aplikasi eksternal. Sebagian Function Module hanya digunakan secara internal oleh SAP sehingga struktur parameter maupun implementasinya dapat berubah antar versi SAP.

Untuk menyediakan antarmuka yang stabil dan terdokumentasi, SAP memperkenalkan **Business Application Programming Interface (BAPI)**.

BAPI merupakan sekumpulan Function Module standar yang dipublikasikan oleh SAP sebagai interface resmi untuk menjalankan proses bisnis tertentu.

---

# Tujuan

BAPI digunakan untuk menjalankan proses bisnis SAP melalui antarmuka yang telah distandarkan.

Contoh proses bisnis.

- Membuat Notification
- Membuat Work Order
- Membuat Purchase Order
- Membuat Equipment
- Mengubah Functional Location

Program tidak perlu mengetahui implementasi internal SAP. Program cukup memanggil BAPI beserta parameter yang dibutuhkan.

---

# Hubungan dengan Function Module

Secara teknis, BAPI merupakan Function Module.

Namun tidak semua Function Module merupakan BAPI.

Hubungannya dapat digambarkan sebagai berikut.

```text
Function Module

├── Function Module Internal SAP

├── Function Module Custom (Z*)

└── BAPI
```

BAPI merupakan Function Module yang dipublikasikan sebagai interface resmi SAP.

---

# Karakteristik BAPI

Sebuah BAPI umumnya memiliki karakteristik berikut.

- Disediakan oleh SAP.
- Memiliki dokumentasi resmi.
- Interface dijaga agar tetap kompatibel.
- Dapat digunakan oleh aplikasi eksternal.
- Digunakan sebagai interface standar untuk proses bisnis SAP.

---

# Penamaan BAPI

Sebagian besar BAPI menggunakan awalan.

```
BAPI_
```

Contoh.

```
BAPI_ALM_NOTIF_CREATE
```

```
BAPI_ALM_ORDER_MAINTAIN
```

```
BAPI_EQUI_CREATE
```

Awalan tersebut memudahkan identifikasi bahwa Function Module tersebut merupakan BAPI.

---

# Cara Kerja

Alur umum penggunaan BAPI.

```text
Program

↓

CALL FUNCTION

↓

BAPI

↓

Business Logic SAP

↓

Return Message

↓

Program
```

Program hanya mengirim parameter.

Seluruh proses bisnis dijalankan oleh SAP.

---

# Contoh Pemanggilan

```abap
CALL FUNCTION 'BAPI_ALM_NOTIF_CREATE'

    EXPORTING

        ...

    IMPORTING

        ...

    TABLES

        return = lt_return.
```

Setelah BAPI selesai dijalankan.

Program memeriksa isi tabel `RETURN`.

---

# RETURN Table

Sebagian besar BAPI tidak hanya menggunakan `SY-SUBRC` sebagai indikator keberhasilan.

Sebaliknya, BAPI biasanya mengembalikan hasil proses melalui parameter `RETURN`.

Contoh.

```abap
CALL FUNCTION 'BAPI_ALM_NOTIF_CREATE'

    TABLES

        return = lt_return.
```

Isi `lt_return` dapat berupa.

| TYPE | MESSAGE |
|------|---------|
| S | Notification Created |
| W | Equipment Locked |
| E | Functional Location Not Found |

Program kemudian membaca isi tabel tersebut untuk mengetahui hasil eksekusi.

---

# Mengapa Tidak Hanya Menggunakan SY-SUBRC?

Business process SAP sering menghasilkan lebih dari satu informasi.

Sebagai contoh.

- Notification berhasil dibuat.
- Equipment sedang di-lock.
- Running Hour belum diperbarui.
- Warning mengenai konfigurasi.

Seluruh informasi tersebut tidak dapat direpresentasikan hanya dengan satu nilai `SY-SUBRC`.

Oleh karena itu, BAPI menggunakan tabel `RETURN` untuk menyampaikan hasil proses secara lebih lengkap.

---

# BAPI dan COMMIT WORK

Sebagian besar BAPI tidak langsung menyimpan perubahan ke database.

Contoh.

```abap
CALL FUNCTION 'BAPI_ALM_NOTIF_CREATE'.
```

Notification belum tentu langsung tersimpan.

Program perlu mengakhiri transaksi menggunakan.

```abap
CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
```

atau mekanisme transaksi lain yang direkomendasikan oleh SAP.

Dengan demikian.

```text
CALL BAPI

↓

Business Logic

↓

RETURN

↓

BAPI_TRANSACTION_COMMIT

↓

Database
```

---

# Contoh Kasus SAP PM

Business Requirement.

> Buat Notification apabila Motor mengalami TRIP.

Program.

```abap
IF ls_motor-status = 'TRIP'.

    CALL FUNCTION 'BAPI_ALM_NOTIF_CREATE'

        ...

ENDIF.
```

Setelah BAPI selesai dijalankan.

Program memeriksa tabel `RETURN`.

Apabila tidak terdapat Error.

```abap
CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
```

Notification kemudian disimpan ke database.

---

# Function Module vs BAPI

| Function Module | BAPI |
|-----------------|------|
| Dapat dibuat oleh SAP maupun perusahaan | Disediakan dan dipublikasikan oleh SAP |
| Interface tidak selalu stabil | Interface dijaga agar tetap kompatibel |
| Tidak selalu terdokumentasi | Memiliki dokumentasi resmi |
| Umumnya digunakan di dalam sistem SAP | Dapat digunakan oleh aplikasi internal maupun eksternal |

---

# BAPI vs PERFORM

| PERFORM | BAPI |
|----------|------|
| Menjalankan subroutine pada program yang sama | Menjalankan proses bisnis SAP |
| Berlaku pada satu program | Dapat digunakan oleh berbagai program maupun aplikasi eksternal |
| Tidak memiliki interface standar | Memiliki interface yang terdokumentasi |

---

# Praktik yang Umum Digunakan

Urutan proses pada aplikasi SAP.

```text
Business Rule

↓

CALL BAPI

↓

Periksa RETURN

↓

BAPI_TRANSACTION_COMMIT

↓

Database
```

Apabila ditemukan Error pada `RETURN`, transaksi umumnya tidak dilanjutkan.

---

# Kesalahan yang Sering Terjadi

## Hanya Memeriksa SY-SUBRC

Pada banyak BAPI, pemeriksaan `SY-SUBRC` saja tidak cukup.

Program juga perlu memeriksa isi tabel `RETURN` untuk mengetahui apakah terdapat Error atau Warning.

---

## Tidak Melakukan Commit

Sebagian besar BAPI yang melakukan perubahan data memerlukan `BAPI_TRANSACTION_COMMIT`.

Apabila commit tidak dilakukan, perubahan dapat tidak tersimpan ke database.

---

## Menggunakan Function Module Internal SAP

Sebisa mungkin gunakan BAPI apabila SAP telah menyediakan interface resminya.

Pendekatan tersebut lebih aman terhadap perubahan versi SAP dibandingkan memanggil Function Module internal secara langsung.

---

# Ringkasan

- BAPI merupakan Function Module standar yang dipublikasikan oleh SAP.
- BAPI digunakan sebagai interface resmi untuk menjalankan proses bisnis SAP.
- Hasil eksekusi umumnya dikembalikan melalui tabel `RETURN`.
- Sebagian besar BAPI yang mengubah data memerlukan `BAPI_TRANSACTION_COMMIT`.
- Apabila tersedia BAPI untuk suatu proses bisnis, penggunaannya lebih disarankan dibandingkan menggunakan Function Module internal SAP.