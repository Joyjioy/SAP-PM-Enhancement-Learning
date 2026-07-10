# MESSAGE

## Latar Belakang

Pada saat program dijalankan, sistem perlu memberikan informasi mengenai hasil proses yang sedang berlangsung. Informasi tersebut dapat berupa pemberitahuan bahwa proses berhasil, peringatan mengenai kondisi tertentu, maupun error yang menyebabkan proses tidak dapat dilanjutkan.

ABAP menyediakan statement `MESSAGE` sebagai mekanisme standar untuk berkomunikasi dengan pengguna.

Berbeda dengan `WRITE`, statement `MESSAGE` merupakan bagian dari mekanisme runtime SAP sehingga dapat memengaruhi alur eksekusi program.

---

# Tujuan

`MESSAGE` digunakan untuk menyampaikan hasil validasi, status proses, maupun kesalahan yang terjadi selama program dijalankan.

Pada SAP PM, `MESSAGE` sering digunakan untuk:

- Menolak penyimpanan data yang tidak valid.
- Memberikan peringatan kepada pengguna.
- Menampilkan informasi bahwa proses berhasil.
- Menghentikan transaksi apabila business rule tidak terpenuhi.

---

# Sintaks Dasar

```abap
MESSAGE 'Permit Required' TYPE 'E'.
```

Pada contoh tersebut, program menampilkan pesan **Permit Required** dengan tipe **Error**.

---

# Struktur Statement

```abap
MESSAGE <text> TYPE <type>.
```

Komponen utama terdiri atas:

- Isi pesan.
- Tipe pesan.

Contoh.

```abap
MESSAGE 'Equipment Saved' TYPE 'S'.
```

---

# Jenis Message

ABAP mengenal beberapa tipe Message.

| Tipe | Nama | Fungsi |
|------|------|--------|
| S | Success | Menampilkan informasi bahwa proses berhasil |
| I | Information | Menampilkan informasi kepada pengguna |
| W | Warning | Memberikan peringatan, tetapi proses masih dapat dilanjutkan |
| E | Error | Menampilkan kesalahan dan menghentikan proses saat ini |
| A | Abort | Menghentikan program secara langsung |
| X | Exit | Menghasilkan runtime error (digunakan pada kondisi tertentu) |

Dalam pengembangan SAP PM, tipe yang paling sering digunakan adalah `S`, `W`, dan `E`.

---

# MESSAGE TYPE 'S'

Digunakan untuk menunjukkan bahwa proses berhasil diselesaikan.

Contoh.

```abap
MESSAGE 'Notification Created' TYPE 'S'.
```

Contoh penggunaan.

- Notification berhasil dibuat.
- Work Order berhasil disimpan.
- Equipment berhasil diperbarui.

---

# MESSAGE TYPE 'I'

Digunakan untuk memberikan informasi kepada pengguna.

Contoh.

```abap
MESSAGE 'Equipment sedang diproses' TYPE 'I'.
```

Message ini tidak menunjukkan adanya kesalahan.

---

# MESSAGE TYPE 'W'

Digunakan ketika terdapat kondisi yang perlu diketahui pengguna tetapi tidak menghalangi proses.

Contoh.

```abap
IF ls_motor-running_hour >= 5500.

    MESSAGE 'Running Hour mendekati jadwal maintenance' TYPE 'W'.

ENDIF.
```

Business rule tetap terpenuhi sehingga proses dapat dilanjutkan.

---

# MESSAGE TYPE 'E'

Digunakan ketika business rule tidak terpenuhi.

Program menghentikan proses saat ini dan meminta pengguna memperbaiki data.

Contoh.

```abap
IF ls_motor-permit IS INITIAL.

    MESSAGE 'Permit Required' TYPE 'E'.

ENDIF.
```

Business Rule.

> Motor Medium Voltage tidak boleh diproses apabila Permit belum diisi.

Karena syarat tidak terpenuhi, proses dihentikan.

---

# Contoh Kasus SAP PM

Business Requirement.

> Notification hanya boleh dibuat apabila Equipment memiliki Permit yang masih berlaku.

Implementasi.

```abap
IF ls_motor-permit IS INITIAL.

    MESSAGE 'Permit Required' TYPE 'E'.

ENDIF.

CALL FUNCTION 'Z_CREATE_NOTIFICATION'

    EXPORTING

        iv_equnr = ls_motor-equnr.
```

Pada contoh tersebut.

Function Module hanya dijalankan apabila Permit tersedia.

Apabila Permit kosong, program berhenti pada statement `MESSAGE`.

---

# MESSAGE dan Business Rule

Sebagian besar `MESSAGE TYPE 'E'` merupakan implementasi langsung dari business rule.

Contoh.

Business Rule.

```
Equipment harus memiliki Permit.
```

Implementasi.

```abap
IF ls_motor-permit IS INITIAL.

    MESSAGE 'Permit Required' TYPE 'E'.

ENDIF.
```

Business Rule.

```
Running Hour tidak boleh bernilai negatif.
```

Implementasi.

```abap
IF ls_motor-running_hour < 0.

    MESSAGE 'Invalid Running Hour' TYPE 'E'.

ENDIF.
```

Dengan demikian, `MESSAGE` menjadi mekanisme untuk memastikan aturan bisnis dipatuhi sebelum program melanjutkan proses.

---

# MESSAGE vs WRITE

Keduanya sama-sama menampilkan informasi, tetapi memiliki tujuan yang berbeda.

| WRITE | MESSAGE |
|--------|---------|
| Menampilkan teks pada output program | Berkomunikasi dengan pengguna melalui mekanisme SAP |
| Tidak memengaruhi alur program | Dapat memengaruhi alur program |
| Umumnya digunakan pada report sederhana | Digunakan pada transaksi SAP |

Pada pengembangan aplikasi SAP, `MESSAGE` jauh lebih umum digunakan dibandingkan `WRITE`.

---

# Praktik yang Umum Digunakan

Validasi dilakukan terlebih dahulu.

```abap
IF ls_motor-permit IS INITIAL.

    MESSAGE 'Permit Required' TYPE 'E'.

ENDIF.
```

Setelah seluruh validasi berhasil.

```abap
CALL FUNCTION 'Z_CREATE_NOTIFICATION'

    EXPORTING

        iv_equnr = ls_motor-equnr.
```

Urutan tersebut memastikan proses bisnis hanya dijalankan apabila seluruh persyaratan telah terpenuhi.

---

# Kesalahan yang Sering Terjadi

## Menggunakan WRITE untuk Validasi

```abap
IF ls_motor-permit IS INITIAL.

    WRITE 'Permit Required'.

ENDIF.
```

Pendekatan tersebut hanya menampilkan teks dan tidak menghentikan proses.

Untuk validasi business rule sebaiknya digunakan `MESSAGE TYPE 'E'`.

---

## Menampilkan Error Setelah Data Disimpan

```abap
CALL FUNCTION 'Z_CREATE_NOTIFICATION'.

MESSAGE 'Permit Required' TYPE 'E'.
```

Urutan tersebut tidak sesuai karena Notification sudah dibuat sebelum validasi dilakukan.

Validasi sebaiknya dilakukan sebelum proses penyimpanan atau pemanggilan Function Module.

---

# Ringkasan

- `MESSAGE` digunakan untuk berkomunikasi dengan pengguna melalui mekanisme standar SAP.
- Tipe `S`, `I`, `W`, dan `E` merupakan tipe yang paling sering digunakan.
- `MESSAGE TYPE 'E'` digunakan untuk menghentikan proses apabila business rule tidak terpenuhi.
- Validasi sebaiknya dilakukan sebelum proses bisnis dijalankan.
- Pada pengembangan aplikasi SAP, `MESSAGE` lebih tepat digunakan dibandingkan `WRITE`.