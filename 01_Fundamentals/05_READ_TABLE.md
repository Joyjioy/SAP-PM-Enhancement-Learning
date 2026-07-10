# READ TABLE

## Latar Belakang

Setelah data berhasil dibaca dari database menggunakan `SELECT ... INTO TABLE`, seluruh data berada di dalam Internal Table. Pada tahap ini, program tidak lagi berinteraksi dengan database. Seluruh proses pencarian data dilakukan terhadap Internal Table.

ABAP menyediakan statement `READ TABLE` untuk mencari sebuah record tertentu di dalam Internal Table tanpa harus melakukan `SELECT` ulang ke database.

Penggunaan `READ TABLE` merupakan salah satu pola yang paling sering dijumpai pada program ABAP karena membantu mengurangi akses database yang tidak diperlukan.

---

## Tujuan

`READ TABLE` digunakan untuk mencari satu record tertentu dari sebuah Internal Table berdasarkan suatu kriteria.

Apabila record ditemukan, data tersebut dipindahkan ke Work Area sehingga dapat diproses lebih lanjut.

---

## Sintaks Dasar

```abap
READ TABLE <internal_table>
INTO <work_area>
WITH KEY <field> = <value>.
```

Contoh.

```abap
READ TABLE lt_notification
INTO ls_notification
WITH KEY equnr = ls_motor-equnr.
```

---

## Penjelasan Sintaks

### Internal Table

```abap
lt_notification
```

Merupakan sumber data yang akan dicari.

Misalnya berisi data berikut.

| NOTIF_NO | EQUNR | STATUS |
|----------|--------|--------|
|1001|MTR001|OPEN|
|1002|MTR003|CLOSED|
|1003|MTR005|OPEN|

---

### Work Area

```abap
INTO ls_notification
```

Apabila data ditemukan, satu record hasil pencarian akan disalin ke dalam `ls_notification`.

Misalnya hasil pencarian menemukan:

| NOTIF_NO | EQUNR | STATUS |
|----------|--------|--------|
|1003|MTR005|OPEN|

Maka isi `ls_notification` menjadi sama dengan record tersebut.

---

### WITH KEY

```abap
WITH KEY equnr = ls_motor-equnr
```

Menentukan kriteria pencarian pada Internal Table.

Pada contoh tersebut, program mencari record yang memiliki nilai `EQUNR` sama dengan nilai `EQUNR` milik motor yang sedang diproses.

Misalnya:

```text
ls_motor-equnr = MTR005
```

Maka proses pencarian menjadi:

```text
Cari record pada lt_notification
dengan EQUNR = MTR005
```

---

## Alur Kerja

Misalkan program memiliki data sebagai berikut.

### Internal Table Notification

| NOTIF_NO | EQUNR | STATUS |
|----------|--------|--------|
|1001|MTR001|OPEN|
|1002|MTR003|CLOSED|
|1003|MTR005|OPEN|

### Motor yang sedang diproses

```text
ls_motor-equnr = MTR005
```

Program menjalankan:

```abap
READ TABLE lt_notification
INTO ls_notification
WITH KEY equnr = ls_motor-equnr.
```

Hasilnya.

```text
Record ditemukan

↓

ls_notification berisi data Notification 1003
```

---

## Pemeriksaan Hasil Pencarian

`READ TABLE` tidak menghasilkan nilai TRUE atau FALSE.

ABAP menggunakan system field `SY-SUBRC` untuk menunjukkan hasil eksekusi statement.

```abap
READ TABLE ...

IF sy-subrc = 0.

    ...

ENDIF.
```

Nilai `SY-SUBRC` yang paling sering digunakan adalah:

| Nilai | Arti |
|--------|------|
|0|Record ditemukan|
|Selain 0|Record tidak ditemukan|

Contoh.

```abap
READ TABLE lt_notification
INTO ls_notification
WITH KEY equnr = ls_motor-equnr.

IF sy-subrc = 0.

    WRITE 'Notification Found'.

ENDIF.
```

---

## Contoh Kasus SAP PM

Business Requirement:

Satu Equipment hanya boleh memiliki satu Notification dengan status `OPEN`.

Flow program:

```text
Motor TRIP

↓

Cari Notification OPEN

↓

Ketemu?

↓

Ya
↓

Jangan buat Notification baru

↓

Tidak

↓

Create Notification
```

Implementasi.

```abap
READ TABLE lt_notification
INTO ls_notification
WITH KEY equnr = ls_motor-equnr.

IF sy-subrc <> 0.

    PERFORM create_notification.

ENDIF.
```

Pada contoh tersebut, program hanya membuat Notification apabila Equipment belum memiliki Notification yang sedang aktif.

---

## Perbedaan READ TABLE dan SELECT

Kedua statement sama-sama digunakan untuk mencari data, tetapi bekerja pada tempat yang berbeda.

| SELECT | READ TABLE |
|----------|------------|
|Mencari data pada Database SAP|Mencari data pada Internal Table|
|Menggunakan `WHERE`|Menggunakan `WITH KEY`|
|Berkomunikasi dengan database|Berkomunikasi dengan data yang sudah berada di memori|
|Lebih lambat dibanding pencarian di Internal Table|Lebih cepat karena dilakukan di RAM|

Perbedaan ini penting karena menentukan kapan masing-masing statement digunakan.

Pola yang umum digunakan pada program ABAP adalah:

```text
Database

↓

SELECT ... WHERE

↓

Internal Table

↓

READ TABLE ... WITH KEY
```

---

## Praktik yang Umum Digunakan

Apabila seluruh data yang dibutuhkan sudah tersedia di Internal Table, gunakan `READ TABLE` untuk melakukan pencarian.

Hindari melakukan `SELECT` berulang kali di dalam `LOOP` apabila data yang sama sudah tersedia di memori.

Pendekatan tersebut mengurangi jumlah akses ke database dan meningkatkan performa program.

---

## Ringkasan

- `READ TABLE` digunakan untuk mencari data pada Internal Table.
- Hasil pencarian disimpan ke dalam Work Area.
- Kriteria pencarian ditentukan menggunakan `WITH KEY`.
- Hasil pencarian diperiksa melalui `SY-SUBRC`.
- `READ TABLE` merupakan alternatif yang lebih efisien dibanding melakukan `SELECT` ulang apabila data sudah tersedia di Internal Table.