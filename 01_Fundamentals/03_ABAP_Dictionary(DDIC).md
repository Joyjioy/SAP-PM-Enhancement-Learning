# ABAP Dictionary (DDIC)

## Latar Belakang

Program ABAP bekerja dengan data yang disimpan di dalam database SAP. Namun, programmer ABAP tidak berinteraksi langsung dengan tabel database fisik menggunakan SQL seperti pada sistem database biasa.

SAP menyediakan sebuah lapisan yang disebut **ABAP Dictionary (DDIC)** sebagai pusat definisi seluruh objek data yang digunakan oleh sistem.

Melalui ABAP Dictionary, programmer mendefinisikan struktur data yang akan digunakan oleh seluruh program ABAP. Dengan pendekatan ini, semua aplikasi menggunakan definisi data yang sama sehingga konsistensi sistem dapat dijaga.

---

# Tujuan

ABAP Dictionary digunakan untuk mendefinisikan struktur data yang digunakan oleh aplikasi SAP.

Objek yang didefinisikan pada DDIC dapat digunakan kembali oleh berbagai program ABAP sehingga tidak perlu dibuat berulang kali.

---

# Posisi DDIC dalam Arsitektur SAP

Hubungan DDIC dengan komponen SAP lainnya dapat digambarkan sebagai berikut.

```text
User

↓

SAP Transaction

↓

ABAP Program

↓

ABAP Dictionary (DDIC)

↓

Database
```

Program ABAP tidak langsung mengetahui struktur tabel database.

Program membaca definisi tersebut dari ABAP Dictionary.

---

# Mengapa DDIC Diperlukan?

Misalkan perusahaan memiliki tabel Equipment.

Tabel tersebut memiliki field.

- Equipment Number
- Description
- Voltage
- Running Hour
- Status

Apabila setiap programmer mendefinisikan struktur tersebut sendiri, kemungkinan akan muncul perbedaan.

Sebagai contoh.

Program A.

```
Voltage : INTEGER
```

Program B.

```
Voltage : CHAR 10
```

Program C.

```
Voltage : DECIMAL
```

Perbedaan tersebut dapat menyebabkan inkonsistensi data.

Dengan DDIC, struktur hanya didefinisikan satu kali kemudian digunakan oleh seluruh program.

---

# Objek pada ABAP Dictionary

ABAP Dictionary terdiri atas beberapa jenis objek.

| Objek | Fungsi |
|--------|--------|
| Table | Menyimpan data |
| Structure | Mengelompokkan field tanpa menyimpan data |
| Data Element | Mendefinisikan arti suatu field |
| Domain | Mendefinisikan tipe dan aturan data |
| View | Menampilkan gabungan beberapa tabel |
| Search Help | Membantu pencarian data |
| Lock Object | Mengatur penguncian data |

Seluruh objek tersebut saling berhubungan.

---

# Table

## Definisi

Table merupakan objek yang digunakan untuk menyimpan data secara permanen.

Contoh.

```
ZEQUIPMENT
```

Misalnya memiliki struktur.

| EQUNR | DESCRIPTION | VOLTAGE | STATUS |
|--------|-------------|----------|---------|
|MTR001|Cooling Pump|6000|TRIP|
|MTR002|Boiler Pump|380|RUNNING|

Program ABAP membaca data tersebut menggunakan.

```abap
SELECT *
FROM zequipment.
```

---

# Structure

## Definisi

Structure merupakan kumpulan field yang memiliki bentuk tertentu tetapi tidak menyimpan data.

Structure digunakan sebagai template.

Contoh.

```
ZS_EQUIPMENT
```

Field.

```
EQUNR

DESCRIPTION

STATUS
```

Structure sering digunakan untuk.

- Work Area
- Parameter Function Module
- Parameter Method

---

# Domain

## Definisi

Domain mendefinisikan karakteristik teknis suatu field.

Contohnya.

- Tipe data
- Panjang data
- Nilai yang diperbolehkan

Misalnya.

```
Voltage

Type : NUMC

Length : 4
```

Seluruh field Voltage yang menggunakan Domain tersebut akan memiliki karakteristik yang sama.

---

# Data Element

## Definisi

Data Element mendefinisikan arti bisnis dari sebuah field.

Misalnya.

```
Voltage
```

Secara teknis dapat menggunakan Domain yang sama.

Namun Data Element memberikan makna bahwa field tersebut merupakan tegangan Equipment.

Data Element juga menyimpan.

- Label field
- Deskripsi
- Dokumentasi

---

# Hubungan Domain dan Data Element

Hubungannya dapat digambarkan sebagai berikut.

```text
Domain

↓

Karakteristik Teknis

↓

Data Element

↓

Makna Bisnis

↓

Field pada Table
```

Domain menjawab pertanyaan.

> Bagaimana data disimpan?

Data Element menjawab pertanyaan.

> Data tersebut merepresentasikan apa?

---

# View

## Definisi

View merupakan representasi data yang berasal dari satu atau beberapa tabel.

View digunakan ketika program memerlukan kombinasi data tanpa harus membuat tabel baru.

Sebagai contoh.

```
Equipment

+

Functional Location

+

Plant
```

Program cukup membaca View tersebut.

---

# Search Help

## Definisi

Search Help digunakan untuk menyediakan fasilitas pencarian pada SAP.

Contohnya.

Ketika user menekan tombol F4 pada field Equipment.

```
F4

↓

Search Help

↓

Daftar Equipment
```

Search Help mengambil data yang sesuai kemudian menampilkannya kepada pengguna.

---

# Lock Object

## Definisi

Lock Object digunakan untuk mencegah dua pengguna mengubah data yang sama secara bersamaan.

Contoh.

User A sedang mengubah Equipment.

```
MTR001
```

Pada saat yang sama.

User B mencoba mengubah Equipment yang sama.

SAP akan mendeteksi bahwa data sedang digunakan sehingga perubahan tidak saling menimpa.

---

# Hubungan DDIC dengan ABAP

Program ABAP memanfaatkan objek DDIC selama proses pengembangan.

Contoh.

```abap
DATA ls_motor TYPE zequipment.

DATA lt_motor TYPE TABLE OF zequipment.
```

Pada contoh tersebut.

`ZEQUIPMENT` bukan dibuat oleh program.

Strukturnya berasal dari ABAP Dictionary.

Demikian pula.

```abap
SELECT *
FROM zequipment.
```

ABAP membaca tabel yang telah didefinisikan pada DDIC.

---

# Hubungan Antar Objek

Hubungan objek pada DDIC dapat digambarkan sebagai berikut.

```text
Domain

↓

Data Element

↓

Field

↓

Table

↓

SELECT

↓

Internal Table

↓

Program ABAP
```

Dengan demikian, DDIC menjadi fondasi bagi seluruh program ABAP.

---

# Praktik yang Umum Digunakan

Ketika menerima business requirement baru, programmer biasanya melakukan langkah berikut.

1. Memeriksa apakah tabel yang dibutuhkan sudah tersedia.
2. Memeriksa struktur tabel melalui DDIC.
3. Menentukan field yang akan digunakan.
4. Menulis program ABAP.

Pada banyak kasus, programmer lebih dahulu membuka transaksi **SE11** untuk mempelajari struktur data sebelum mulai menulis kode.

---

# Ringkasan

- ABAP Dictionary merupakan pusat definisi struktur data pada SAP.
- DDIC memastikan seluruh program menggunakan definisi data yang konsisten.
- Objek utama DDIC meliputi Table, Structure, Domain, Data Element, View, Search Help, dan Lock Object.
- Program ABAP menggunakan objek DDIC sebagai dasar untuk membaca, memproses, maupun menyimpan data.
- Sebelum menulis program ABAP, programmer umumnya mempelajari struktur data melalui ABAP Dictionary.