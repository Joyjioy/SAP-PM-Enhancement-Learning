# ABAP Program Flow

## Latar Belakang

Program ABAP terdiri atas banyak statement seperti `SELECT`, `LOOP`, `READ TABLE`, `CALL FUNCTION`, dan `COMMIT WORK`.

Masing-masing statement memiliki fungsi yang berbeda, tetapi seluruhnya merupakan bagian dari satu alur eksekusi program.

Memahami alur tersebut lebih penting daripada menghafal sintaks, karena programmer perlu mengetahui tujuan setiap statement dalam keseluruhan proses bisnis.

---

# Gambaran Umum

Secara umum program ABAP berjalan mengikuti alur berikut.

```text
User

↓

Menjalankan Transaksi SAP

↓

Program ABAP Dimulai

↓

SELECT

↓

Internal Table

↓

LOOP

↓

IF / CASE

↓

READ TABLE

↓

PERFORM / METHOD

↓

CALL FUNCTION / BAPI

↓

MESSAGE

↓

COMMIT WORK

↓

Database
```

---

# Penjelasan Setiap Tahap

## 1. User Menjalankan Transaksi

Pengguna membuka transaksi SAP, misalnya membuat Notification atau mengubah Equipment.

Program ABAP mulai dijalankan.

---

## 2. SELECT

Program membaca data yang diperlukan dari database.

Hasil pembacaan disimpan ke Internal Table.

---

## 3. Internal Table

Seluruh data berada di memori sehingga dapat diproses tanpa harus terus mengakses database.

---

## 4. LOOP

Program memproses setiap record satu per satu.

---

## 5. IF / CASE

Business Rule dievaluasi.

Contoh.

- Status TRIP.
- Running Hour > 6000.
- Permit tersedia.

---

## 6. READ TABLE

Program mencari data pendukung pada Internal Table lain.

Misalnya.

- Notification.
- Work Order.
- Permit.

---

## 7. PERFORM atau METHOD

Logika yang lebih kompleks dipindahkan ke subroutine atau object.

---

## 8. CALL FUNCTION atau BAPI

Program menjalankan proses bisnis SAP.

Misalnya.

- Membuat Notification.
- Membuat Work Order.
- Mengubah Equipment.

---

## 9. MESSAGE

Program memberikan informasi kepada pengguna apabila diperlukan.

---

## 10. COMMIT WORK

Seluruh perubahan transaksi disimpan ke database.

---

# Hubungan Antar Dokumen

Dokumen repository ini mengikuti alur tersebut.

```
SAP

↓

ABAP

↓

Program Flow

↓

SELECT

↓

Internal Table

↓

READ TABLE

↓

LOOP

↓

APPEND

↓

MODIFY

↓

PERFORM

↓

Function Module

↓

OOP

↓

IF

↓

MESSAGE

↓

CALL FUNCTION

↓

COMMIT WORK

↓

BAPI
```

Dengan memahami urutan tersebut, setiap konsep ABAP dapat diposisikan dalam keseluruhan proses eksekusi program.

---

# Ringkasan

- Program ABAP merupakan rangkaian beberapa statement yang bekerja secara berurutan.
- Setiap statement memiliki tanggung jawab yang berbeda dalam proses bisnis.
- Memahami alur program lebih penting daripada menghafal sintaks secara terpisah.
- Seluruh dokumen pada repository ini disusun mengikuti urutan eksekusi program ABAP.