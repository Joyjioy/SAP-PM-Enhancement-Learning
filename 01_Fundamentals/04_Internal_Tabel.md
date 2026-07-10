# Internal Table

## Latar Belakang

Sebagian besar program ABAP bekerja dengan data yang berasal dari database SAP. Setiap akses ke database membutuhkan waktu eksekusi yang lebih besar dibandingkan pemrosesan data di memori. Apabila program melakukan query database berulang kali di dalam proses bisnis, performa sistem akan menurun secara signifikan.

Untuk mengurangi jumlah akses ke database, hasil pembacaan data biasanya disimpan terlebih dahulu ke dalam Internal Table. Setelah data berada di Internal Table, seluruh proses pencarian, filtering, validasi, maupun perhitungan dilakukan di memori.

Prinsip ini merupakan salah satu dasar optimasi performa pada pengembangan program ABAP.

---

## Definisi

Internal Table adalah struktur data sementara yang berada di memori (RAM) selama program ABAP berjalan. Internal Table digunakan untuk menyimpan sekumpulan record yang memiliki struktur data yang sama.

Data pada Internal Table hanya tersedia selama program dieksekusi dan akan hilang ketika program selesai.

Internal Table bukan merupakan tabel database dan tidak menyimpan data secara permanen.

---

## Posisi Internal Table pada Alur Program

Secara umum alur pengolahan data pada program ABAP ditunjukkan sebagai berikut.

```text
Database
    │
    ▼
SELECT ... INTO TABLE
    │
    ▼
Internal Table
    │
    ├── LOOP
    ├── READ TABLE
    ├── APPEND
    ├── MODIFY
    └── DELETE
```

Database digunakan untuk mengambil atau menyimpan data permanen. Setelah proses `SELECT` selesai, program bekerja menggunakan Internal Table sehingga akses ke database tidak perlu dilakukan kembali selama data yang dibutuhkan masih tersedia di memori.

---

## Komponen Internal Table

Dalam implementasi ABAP, Internal Table hampir selalu digunakan bersama sebuah Work Area.

### Internal Table (`lt_*`)

Internal Table menyimpan seluruh record hasil pembacaan database.

Contoh deklarasi.

```abap
DATA lt_motor TYPE TABLE OF zequipment.
```

Misalkan tabel `zequipment` berisi data berikut.

| EQUNR | DESCRIPTION | VOLTAGE | STATUS |
|-------|-------------|---------|---------|
| MTR001 | Cooling Pump | 6000 | TRIP |
| MTR002 | Boiler Pump | 380 | RUNNING |
| MTR003 | Compressor | 6000 | RUNNING |

Setelah program menjalankan:

```abap
SELECT *
  FROM zequipment
  INTO TABLE lt_motor.
```

Seluruh record tersebut berada di dalam `lt_motor`.

---

### Work Area (`ls_*`)

Work Area digunakan untuk menyimpan satu record yang sedang diproses.

Contoh deklarasi.

```abap
DATA ls_motor TYPE zequipment.
```

Work Area tidak menyimpan seluruh isi Internal Table. Nilainya berubah setiap kali program memproses record yang berbeda.

---

## Hubungan Internal Table dan Work Area

Contoh proses iterasi.

```abap
LOOP AT lt_motor INTO ls_motor.

ENDLOOP.
```

Misalkan `lt_motor` berisi tiga record.

| Iterasi | Isi `ls_motor` |
|----------|----------------|
| 1 | MTR001 |
| 2 | MTR002 |
| 3 | MTR003 |

Pada setiap iterasi, satu record dari Internal Table dipindahkan ke Work Area untuk diproses.

Sebagian besar logika program ABAP dijalankan terhadap Work Area, bukan langsung terhadap Internal Table.

Contoh.

```abap
LOOP AT lt_motor INTO ls_motor.

    IF ls_motor-status = 'TRIP'.

        ...

    ENDIF.

ENDLOOP.
```

Pada contoh tersebut, proses pemeriksaan status dilakukan terhadap record yang sedang berada pada `ls_motor`.

---

## Operasi Dasar pada Internal Table

Beberapa operasi yang paling sering digunakan terhadap Internal Table adalah sebagai berikut.

| Operasi | Tujuan |
|----------|--------|
| LOOP AT | Memproses seluruh record pada Internal Table |
| READ TABLE | Mencari satu record tertentu |
| APPEND | Menambahkan record baru |
| MODIFY | Mengubah record yang sudah ada |
| DELETE | Menghapus record |
| SORT | Mengurutkan data berdasarkan field tertentu |

Operasi-operasi tersebut dilakukan sepenuhnya di memori tanpa mengakses database.

---

## Internal Table vs Database Table

| Database Table | Internal Table |
|----------------|----------------|
| Disimpan secara permanen di server SAP | Disimpan sementara di memori |
| Diakses menggunakan `SELECT`, `INSERT`, `UPDATE`, `DELETE` | Diakses menggunakan `LOOP`, `READ TABLE`, `APPEND`, `MODIFY`, `DELETE` |
| Digunakan sebagai sumber data utama | Digunakan untuk pemrosesan data selama program berjalan |

Perbedaan ini penting karena menentukan keyword ABAP yang digunakan. Misalnya:

- `WHERE` digunakan ketika melakukan pencarian pada database.
- `WITH KEY` digunakan ketika melakukan pencarian pada Internal Table.

Topik mengenai `READ TABLE` dan `WITH KEY` dibahas lebih lanjut pada dokumen **READ_TABLE.md**.

---

## Praktik yang Umum Digunakan

Program ABAP yang memiliki performa baik umumnya mengikuti pola berikut.

1. Mengambil seluruh data yang diperlukan menggunakan `SELECT`.
2. Menyimpan hasil pembacaan ke Internal Table.
3. Melakukan seluruh proses bisnis terhadap Internal Table.
4. Mengakses database kembali hanya apabila diperlukan untuk menyimpan perubahan.

Pola ini mengurangi jumlah akses ke database dan membuat program lebih efisien.

---

## Ringkasan

- Internal Table merupakan tempat penyimpanan sementara data di memori.
- Internal Table digunakan setelah proses `SELECT` selesai dilakukan.
- Sebagian besar business logic dijalankan terhadap data di Internal Table.
- Work Area digunakan untuk memproses satu record pada setiap iterasi.
- Operasi seperti `LOOP`, `READ TABLE`, `APPEND`, dan `MODIFY` bekerja pada Internal Table, bukan pada database.