# Case Studies

Folder ini berisi kumpulan studi kasus yang menggambarkan proses pengembangan sebuah program maintenance di SAP PM.

Setiap case merupakan **enhancement** terhadap program sebelumnya. Dengan demikian pembaca dapat melihat bagaimana business rule berkembang seiring munculnya kebutuhan baru dari departemen Maintenance, Reliability, maupun HSE.

Seluruh studi kasus menggunakan Mock Database yang sama sehingga setiap perubahan business rule dapat diuji menggunakan data yang konsisten.

---

## Relationship Between Cases

```text
Case 01
Automatically Create Notification
        │
        ▼
Case 02
Prevent Duplicate Notification
        │
        ▼
Case 03
Running Hour Validation
        │
        ▼
Case 04
Permit Validation
        │
        ▼
Case 05
Automatically Create Work Order
        │
        ▼
Case 06
Final Enhancement
```

Program tidak dibangun sekaligus.

Setiap case menambahkan satu business rule baru sehingga perubahan dapat dipahami secara bertahap.

---

# Case 01 - Automatically Create Notification

Program pertama kali dibuat untuk membantu engineer membuat Notification secara otomatis.

Business rule yang diterapkan masih sederhana.

- Equipment harus berstatus **TRIP**.
- Belum terdapat Notification aktif.

Jika kedua syarat tersebut terpenuhi, sistem membuat Notification baru.

---

# Case 02 - Prevent Duplicate Notification

Setelah program digunakan, ditemukan masalah bahwa Equipment yang sama dapat memiliki lebih dari satu Notification aktif.

Business rule kemudian diperbarui.

Sebelum membuat Notification, sistem harus memastikan bahwa belum terdapat Notification dengan status **OPEN** atau **IN_PROCESS**.

Dengan enhancement ini setiap Equipment hanya memiliki satu Notification aktif untuk satu permasalahan.

---

# Case 03 - Running Hour Validation

Program masih menghasilkan terlalu banyak Notification.

Departemen Maintenance kemudian menambahkan syarat baru.

Notification hanya boleh dibuat apabila Running Hour Equipment telah melebihi **6000 jam**.

Validasi ini bertujuan agar Notification lebih sesuai dengan kondisi operasi Equipment.

---

# Case 04 - Permit Validation

Departemen HSE mengusulkan validasi tambahan.

Meskipun seluruh syarat sebelumnya telah terpenuhi, Notification tidak boleh dibuat apabila Permit belum disetujui.

Program kemudian melakukan pemeriksaan terhadap status Permit sebelum melanjutkan proses.

Hanya Permit dengan status **APPROVED** yang diperbolehkan.

---

# Case 05 - Automatically Create Work Order

Setelah Notification berhasil dibuat, proses berikutnya masih dilakukan secara manual oleh Maintenance Planner.

Enhancement berikutnya adalah membuat Work Order secara otomatis.

Sistem memeriksa apakah Notification aktif sudah memiliki Work Order.

Jika belum ada, Work Order baru akan dibuat.

---

# Case 06 - Final Enhancement

Case terakhir merupakan implementasi akhir dari seluruh enhancement sebelumnya.

Program menjalankan seluruh business rule dalam satu alur.

```text
Equipment

↓

Status = TRIP

↓

Running Hour > 6000

↓

Permit = APPROVED

↓

Notification Active Exists?

↓

No

↓

Create Notification

↓

Work Order Exists?

↓

No

↓

Create Work Order
```

Case ini merepresentasikan bagaimana sebuah program maintenance berkembang dari requirement sederhana menjadi proses bisnis yang lebih lengkap.

---

## Learning Objectives

Melalui keenam studi kasus ini, pembaca diharapkan dapat memahami:

- Cara menerjemahkan business requirement menjadi logika program.
- Cara membaca hubungan antar tabel pada SAP PM.
- Cara menggunakan Internal Table sebagai media validasi data.
- Cara menerapkan enhancement tanpa mengubah alur utama program.
- Cara mengembangkan business rule secara bertahap sesuai kebutuhan operasional.

Seluruh studi kasus dirancang menggunakan Mock Database yang tersedia pada folder **04_Mock_Data**, sehingga setiap implementasi dapat diuji dengan data yang sama dan menghasilkan perilaku program yang konsisten.