# APPEND

## Latar Belakang

Selama proses bisnis berlangsung, program tidak selalu hanya membaca data yang berasal dari database. Dalam banyak kasus, program perlu membentuk kumpulan data baru yang akan digunakan pada proses berikutnya.

Contohnya:

- Menyimpan daftar Equipment yang memenuhi suatu kriteria.
- Menyimpan histori Notification yang baru dibuat.
- Menyusun daftar Work Order yang akan diproses.
- Mengumpulkan hasil validasi sebelum ditampilkan ke pengguna.

Pada kondisi tersebut, program memerlukan cara untuk menambahkan record baru ke dalam Internal Table. Statement `APPEND` digunakan untuk tujuan tersebut.

---

## Tujuan

`APPEND` digunakan untuk menambahkan satu record baru ke bagian akhir Internal Table.

Record yang ditambahkan umumnya berasal dari sebuah Work Area yang telah diisi sebelumnya.

---

## Hubungan dengan Konsep Sebelumnya

Alur umum pembentukan Internal Table baru ditunjukkan sebagai berikut.

```text
LOOP

↓

Business Logic

↓

Isi Work Area

↓

APPEND

↓

Internal Table Baru
```

Berbeda dengan `SELECT`, data yang ditambahkan menggunakan `APPEND` tidak berasal dari database, melainkan dibentuk oleh program.

---

## Sintaks Dasar

```abap
APPEND ls_history TO lt_history.
```

---

## Penjelasan Sintaks

### Work Area

```abap
ls_history
```

Berisi satu record yang akan ditambahkan.

---

### Internal Table

```abap
lt_history
```

Merupakan tujuan penambahan data.

Setelah `APPEND` dijalankan, record pada `ls_history` akan disalin ke bagian akhir `lt_history`.

---

## Cara Kerja

Misalkan Internal Table masih kosong.

```text
lt_history

(empty)
```

Program mengisi Work Area.

```abap
ls_history-equnr = 'MTR001'.
ls_history-status = 'TRIP'.
```

Kemudian menjalankan.

```abap
APPEND ls_history TO lt_history.
```

Isi Internal Table menjadi.

| EQUNR | STATUS |
|-------|--------|
|MTR001|TRIP|

Apabila program kembali mengisi `ls_history`.

```abap
ls_history-equnr = 'MTR003'.
ls_history-status = 'RUNNING'.
```

Kemudian menjalankan.

```abap
APPEND ls_history TO lt_history.
```

Isi Internal Table berubah menjadi.

| EQUNR | STATUS |
|-------|--------|
|MTR001|TRIP|
|MTR003|RUNNING|

Setiap pemanggilan `APPEND` selalu menambahkan record baru pada bagian akhir Internal Table.

---

## Contoh Kasus SAP PM

Business Requirement.

> Simpan seluruh Motor Medium Voltage yang berstatus TRIP ke dalam daftar inspeksi.

Program membaca seluruh Equipment.

```abap
SELECT *
FROM zequipment
INTO TABLE lt_motor.
```

Kemudian melakukan iterasi.

```abap
LOOP AT lt_motor INTO ls_motor.

    IF ls_motor-voltage >= 1000
    AND ls_motor-status = 'TRIP'.

        ls_history-equnr = ls_motor-equnr.
        ls_history-status = ls_motor-status.

        APPEND ls_history TO lt_history.

    ENDIF.

ENDLOOP.
```

Pada contoh tersebut.

`lt_motor` merupakan data hasil pembacaan database.

`lt_history` merupakan Internal Table baru yang dibentuk selama program berjalan.

---

## Kapan APPEND Digunakan

Gunakan `APPEND` apabila:

- Membuat Internal Table baru.
- Menambahkan hasil filtering.
- Menyusun data laporan.
- Menyimpan histori proses.
- Mengumpulkan hasil validasi.

---

## Kapan APPEND Tidak Digunakan

`APPEND` tidak digunakan apabila data yang ingin ditambahkan sudah berada di Internal Table tujuan.

Contoh.

```abap
READ TABLE lt_history
INTO ls_history
WITH KEY equnr = ls_motor-equnr.

APPEND ls_history TO lt_history.
```

Pendekatan tersebut umumnya tidak diperlukan.

`READ TABLE` digunakan untuk mencari data yang sudah ada.

`APPEND` digunakan untuk membuat record baru.

Apabila tujuan program adalah menambahkan histori baru, Work Area sebaiknya diisi terlebih dahulu, kemudian langsung dilakukan `APPEND`.

Contoh.

```abap
ls_history-equnr = ls_motor-equnr.
ls_history-status = ls_motor-status.

APPEND ls_history TO lt_history.
```

---

## APPEND vs MODIFY

Kedua statement memiliki tujuan yang berbeda.

| APPEND | MODIFY |
|---------|--------|
| Menambahkan record baru | Mengubah record yang sudah ada |
| Jumlah record bertambah | Jumlah record tetap |
| Digunakan saat membangun Internal Table | Digunakan saat memperbarui isi Internal Table |

Contoh.

Internal Table sebelum `APPEND`.

| EQUNR |
|--------|
|MTR001|
|MTR002|

Setelah.

```abap
APPEND ls_history TO lt_history.
```

Menjadi.

| EQUNR |
|--------|
|MTR001|
|MTR002|
|MTR003|

Jumlah record bertambah.

---

## Praktik yang Umum Digunakan

Pola yang sering dijumpai pada program ABAP adalah.

```abap
LOOP AT lt_motor INTO ls_motor.

    ...

    APPEND ls_history TO lt_history.

ENDLOOP.
```

Setiap iterasi menghasilkan satu record baru yang ditambahkan ke Internal Table.

---

## Ringkasan

- `APPEND` digunakan untuk menambahkan record baru ke Internal Table.
- Record yang ditambahkan berasal dari Work Area.
- `APPEND` selalu menambahkan data pada bagian akhir Internal Table.
- `APPEND` digunakan ketika program membentuk kumpulan data baru.
- `APPEND` berbeda dengan `MODIFY`, karena `MODIFY` digunakan untuk memperbarui data yang sudah ada.