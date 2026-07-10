# ABAP Enhancement Guide for Maintenance Engineer

# 1. Apa itu ABAP Editor

ABAP Editor merupakan editor yang digunakan untuk membuat, membaca, dan mengubah program ABAP di dalam SAP.

Bagi engineer maintenance, ABAP Editor digunakan ketika diperlukan perubahan pada business rule yang sudah berjalan.

Contohnya.

- Menambahkan validasi baru.
- Mengubah urutan proses.
- Menambah kondisi IF.
- Memanggil Function Module.
- Memperbaiki bug.

ABAP Editor bukan tempat melakukan konfigurasi SAP. Seluruh perubahan yang dilakukan di sini akan mempengaruhi logika program.

---

# 2. Membuka ABAP Editor

Masuk ke SAP GUI.

Jalankan Transaction Code.

```
SE38
```

Akan muncul layar ABAP Editor.

Field yang perlu diperhatikan.

| Field | Fungsi |
|--------|--------|
| Program | Nama program yang akan dibuka |
| Display | Melihat program tanpa mengubah |
| Change | Mengubah program |
| Create | Membuat program baru |
| Execute | Menjalankan program |

Sebagian besar enhancement dilakukan dengan membuka program yang sudah ada menggunakan menu **Change**.

---

# 3. Struktur Program ABAP

Program ABAP umumnya memiliki struktur seperti berikut.

```abap
REPORT z_program.

DATA ...

START-OF-SELECTION.

FORM ...

ENDFORM.
```

Bagian yang paling sering diubah ketika melakukan enhancement adalah.

- DATA
- START-OF-SELECTION
- FORM

Engineer maintenance tidak selalu perlu memahami seluruh sintaks ABAP, tetapi harus mampu mengikuti alur program.

---

# 4. Cara Membaca Program

Jangan langsung membaca program dari atas sampai bawah.

Lebih mudah mengikuti urutan berikut.

```
REPORT

↓

START-OF-SELECTION

↓

PERFORM

↓

FORM
```

Contoh.

```abap
START-OF-SELECTION.

PERFORM get_data.

PERFORM process_equipment.
```

Artinya.

Program pertama kali mengambil data, kemudian memproses data tersebut.

Selanjutnya buka FORM yang dipanggil.

```abap
FORM process_equipment.
```

Di dalam FORM inilah biasanya terdapat business rule.

---

# 5. Memahami Requirement

Jangan langsung membuka ABAP ketika menerima requirement.

Langkah pertama adalah menerjemahkan requirement menjadi business rule.

Contoh.

Requirement.

> Notification hanya boleh dibuat apabila Running Hour lebih dari 6000 jam.

Business rule.

```
Running Hour > 6000

↓

Ya

↓

Lanjut

Tidak

↓

Stop
```

Setelah business rule jelas, baru tentukan data yang diperlukan.

Pada contoh di atas diperlukan.

```
Table

Equipment

↓

Field

RUNNING_HOUR
```

---

# 6. Menentukan Data yang Dibutuhkan

Setiap requirement selalu membutuhkan data.

Misalnya.

Requirement.

> Permit harus APPROVED.

Data yang diperlukan.

```
Table

Permit

↓

Field

PERMIT_STATUS
```

Contoh lain.

Requirement.

> Jangan membuat Notification apabila sudah ada Notification aktif.

Data yang diperlukan.

```
Table

Notification

↓

Field

EQUNR

STATUS
```

Jangan menulis kode sebelum mengetahui tabel dan field yang akan digunakan.

---

# 7. Menentukan Lokasi Perubahan

Tidak semua requirement membutuhkan program baru.

Sebagian besar enhancement dilakukan dengan menambahkan beberapa baris logika pada program yang sudah ada.

Contoh.

Business rule lama.

```
Equipment TRIP

↓

Create Notification
```

Business rule baru.

```
Equipment TRIP

↓

Running Hour > 6000

↓

Create Notification
```

Perubahan dilakukan pada bagian proses validasi, bukan dengan membuat program baru.

---

# 8. Menambahkan Business Rule

Contoh requirement.

> Notification hanya boleh dibuat apabila Permit telah APPROVED.

Program lama.

```abap
IF equipment-status = 'TRIP'.

  PERFORM create_notification.

ENDIF.
```

Program setelah enhancement.

```abap
IF equipment-status = 'TRIP'.

  IF permit-status = 'APPROVED'.

    PERFORM create_notification.

  ENDIF.

ENDIF.
```

Perubahan yang dilakukan hanya menambahkan satu validasi baru.

Struktur program tidak berubah.

Inilah yang disebut enhancement.

---

# 9. Melakukan Aktivasi Program

Setelah perubahan selesai.

Langkah berikutnya.

```
Save

↓

Check

↓

Activate
```

Penjelasan.

**Save**

Menyimpan perubahan pada editor.

**Check**

Memeriksa apakah masih terdapat kesalahan sintaks.

Shortcut.

```
Ctrl + F2
```

**Activate**

Mengaktifkan versi terbaru program sehingga dapat digunakan.

Shortcut.

```
Ctrl + F3
```

Program yang belum di-Activate masih menggunakan versi lama.

---

# 10. Melakukan Testing

Setelah Activate.

Jangan langsung menganggap enhancement berhasil.

Lakukan pengujian menggunakan data yang sesuai dengan business rule.

Contoh.

Requirement.

```
Running Hour > 6000
```

Maka gunakan data.

```
Running Hour = 7200
```

dan

```
Running Hour = 3500
```

Pastikan kedua data menghasilkan keputusan yang berbeda.

---

# 11. Menggunakan Breakpoint

Apabila hasil program tidak sesuai.

Tambahkan Breakpoint pada baris yang ingin diperiksa.

Contoh.

```abap
READ TABLE lt_notification
     INTO ls_notification
     WITH KEY equnr = ls_equipment-equnr.
```

Ketika program berhenti pada Breakpoint.

Periksa.

- Isi Internal Table.
- Nilai Variable.
- Nilai SY-SUBRC.
- Apakah IF dijalankan.
- Apakah PERFORM dipanggil.

Debugging sering kali lebih membantu dibanding membaca seluruh program.

---

# 12. Contoh Alur Enhancement

Misalkan engineer menerima requirement berikut.

> Jika Equipment TRIP, Running Hour lebih dari 6000 jam, Permit APPROVED, dan belum ada Notification aktif, maka buat Notification.

Urutan pengerjaan.

```
Terima Requirement

↓

Ubah menjadi Business Rule

↓

Tentukan Table yang Dibutuhkan

↓

Tentukan Field yang Digunakan

↓

Cari Program ABAP

↓

Cari Lokasi Business Rule

↓

Tambahkan Logika

↓

Check

↓

Activate

↓

Testing

↓

Selesai
```

Perhatikan bahwa menulis kode hanyalah satu bagian dari keseluruhan proses.

Sebagian besar waktu justru digunakan untuk memahami requirement dan menentukan lokasi perubahan.

---

# 13. Hubungan dengan Repository Ini

Repository ini mengikuti alur yang sama.

```
01_Fundamentals

↓

02_Mock_Data

↓

03_Case_Studies

↓

04_Code
```

Setiap Case Study menunjukkan bagaimana sebuah requirement diterjemahkan menjadi business rule.

Implementasi ABAP pada folder **04_Code** merupakan contoh bagaimana business rule tersebut diterapkan ke dalam program.

Dengan memahami urutan tersebut, engineer tidak hanya mengetahui cara menulis kode, tetapi juga memahami alasan mengapa suatu logika ditambahkan pada program.