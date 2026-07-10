# MODIFY

## Latar Belakang

Selama proses bisnis berlangsung, program tidak hanya membaca atau menambahkan data ke dalam Internal Table. Pada kondisi tertentu, data yang sudah ada perlu diperbarui karena hasil validasi, perhitungan, maupun perubahan status.

Sebagai contoh:

- Status Equipment berubah dari `RUNNING` menjadi `TRIP`.
- Running Hour diperbarui setelah proses inspeksi.
- Notification diberi status `CLOSED`.
- Work Order diberi status `COMPLETED`.

Pada kondisi tersebut, program tidak membuat record baru, tetapi memperbarui record yang sudah ada. Statement `MODIFY` digunakan untuk tujuan tersebut.

---

## Tujuan

`MODIFY` digunakan untuk memperbarui isi record yang sudah terdapat pada Internal Table.

Berbeda dengan `APPEND`, jumlah record pada Internal Table tidak berubah. Yang berubah hanyalah isi record yang sudah ada.

---

## Hubungan dengan Konsep Sebelumnya

Alur umum penggunaan `MODIFY` ditunjukkan sebagai berikut.

```text
SELECT

↓

Internal Table

↓

LOOP

↓

Ubah isi Work Area

↓

MODIFY

↓

Internal Table diperbarui
```

---

## Sintaks Dasar

```abap
MODIFY lt_motor FROM ls_motor.
```

---

## Penjelasan Sintaks

### Internal Table

```abap
lt_motor
```

Merupakan Internal Table yang akan diperbarui.

---

### Work Area

```abap
ls_motor
```

Berisi nilai terbaru yang akan menggantikan record lama pada Internal Table.

---

## Cara Kerja

Misalkan Internal Table memiliki isi sebagai berikut.

| EQUNR | STATUS |
|-------|--------|
|MTR001|RUNNING|
|MTR002|RUNNING|
|MTR003|RUNNING|

Program menemukan bahwa MTR002 mengalami trip.

Work Area diperbarui.

```abap
ls_motor-status = 'TRIP'.
```

Kemudian program menjalankan.

```abap
MODIFY lt_motor FROM ls_motor.
```

Isi Internal Table berubah menjadi.

| EQUNR | STATUS |
|-------|--------|
|MTR001|RUNNING|
|MTR002|TRIP|
|MTR003|RUNNING|

Jumlah record tetap tiga.

Yang berubah hanya isi record MTR002.

---

## Contoh Kasus SAP PM

Business Requirement.

> Setelah Notification berhasil dibuat, status Equipment diubah menjadi `UNDER_MAINTENANCE`.

Program melakukan iterasi terhadap seluruh Equipment.

```abap
LOOP AT lt_motor INTO ls_motor.

    IF ls_motor-status = 'TRIP'.

        PERFORM create_notification.

        ls_motor-status = 'UNDER_MAINTENANCE'.

        MODIFY lt_motor FROM ls_motor.

    ENDIF.

ENDLOOP.
```

Pada contoh tersebut, setiap Equipment yang memenuhi syarat akan mengalami perubahan status.

Perubahan tersebut disimpan kembali ke Internal Table menggunakan `MODIFY`.

---

## MODIFY dan Database

Perlu diperhatikan bahwa `MODIFY` pada contoh di atas hanya memperbarui Internal Table.

Database SAP belum berubah.

Alur yang terjadi adalah.

```text
Database

↓

SELECT

↓

Internal Table

↓

MODIFY

↓

Internal Table berubah
```

Perubahan baru akan tersimpan ke database apabila program menjalankan proses penyimpanan ke database, misalnya melalui:

- `UPDATE`
- `MODIFY` terhadap database table
- Function Module
- BAPI
- COMMIT WORK

Dengan demikian, `MODIFY` terhadap Internal Table tidak secara otomatis mengubah data di database.

---

## APPEND vs MODIFY

| APPEND | MODIFY |
|---------|--------|
| Menambahkan record baru | Memperbarui record yang sudah ada |
| Jumlah record bertambah | Jumlah record tetap |
| Digunakan ketika membentuk data baru | Digunakan ketika memperbarui data yang sudah ada |

Contoh.

Sebelum.

| EQUNR |
|-------|
|MTR001|
|MTR002|

Menggunakan.

```abap
APPEND ls_motor TO lt_motor.
```

Hasil.

| EQUNR |
|-------|
|MTR001|
|MTR002|
|MTR003|

Jumlah record bertambah.

---

Sebelum.

| EQUNR | STATUS |
|-------|--------|
|MTR001|RUNNING|

Menggunakan.

```abap
MODIFY lt_motor FROM ls_motor.
```

Hasil.

| EQUNR | STATUS |
|-------|--------|
|MTR001|TRIP|

Jumlah record tetap.

---

## APPEND atau MODIFY?

Gunakan pertanyaan berikut.

**Apakah saya sedang membuat record baru?**

Ya

↓

Gunakan `APPEND`

---

**Apakah saya sedang mengubah record yang sudah ada?**

Ya

↓

Gunakan `MODIFY`

---

## Praktik yang Umum Digunakan

Pola yang sering dijumpai pada program ABAP.

```abap
LOOP AT lt_motor INTO ls_motor.

    ...

    ls_motor-status = 'TRIP'.

    MODIFY lt_motor FROM ls_motor.

ENDLOOP.
```

Pada pola tersebut, Work Area diubah terlebih dahulu, kemudian hasil perubahan dituliskan kembali ke Internal Table.

---

## Kesalahan yang Sering Terjadi

### Menggunakan APPEND untuk memperbarui data

Contoh.

```abap
APPEND ls_motor TO lt_motor.
```

Padahal `ls_motor` merupakan record yang sudah ada.

Akibatnya, Internal Table memiliki dua record dengan Equipment yang sama.

Pada kondisi tersebut seharusnya digunakan `MODIFY`.

---

### Mengira MODIFY langsung mengubah database

`MODIFY` terhadap Internal Table hanya mengubah data yang berada di memori.

Apabila perubahan perlu disimpan secara permanen, program harus menjalankan proses penyimpanan ke database.

---

## Ringkasan

- `MODIFY` digunakan untuk memperbarui record yang sudah ada pada Internal Table.
- `MODIFY` tidak menambah jumlah record.
- Perubahan dilakukan terhadap Work Area, kemudian dituliskan kembali ke Internal Table.
- `MODIFY` pada Internal Table tidak secara otomatis memperbarui database.
- Gunakan `APPEND` untuk membuat record baru, dan `MODIFY` untuk memperbarui record yang sudah ada.