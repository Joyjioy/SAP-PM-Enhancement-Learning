REPORT zcase03_runninghour_validation.

TYPES: BEGIN OF ty_equipment,
         equnr         TYPE char10,
         status        TYPE char20,
         running_hour  TYPE i,
       END OF ty_equipment.

TYPES: BEGIN OF ty_notification,
         equnr         TYPE char10,
         status        TYPE char20,
       END OF ty_notification.

DATA: lt_equipment    TYPE TABLE OF ty_equipment,
      lt_notification TYPE TABLE OF ty_notification,
      ls_equipment    TYPE ty_equipment,
      ls_notification TYPE ty_notification.

START-OF-SELECTION.

* Ambil data yang diperlukan untuk menjalankan
* business rule.

  PERFORM get_data.

* Evaluasi setiap equipment berdasarkan
* requirement terbaru.

  PERFORM process_equipment.

FORM get_data.

* Ambil data equipment yang akan dievaluasi.

  SELECT equnr
         status
         running_hour
    FROM zequipment
    INTO TABLE lt_equipment.

* Ambil notification yang masih aktif.

  SELECT equnr
         status
    FROM znotification
    INTO TABLE lt_notification
    WHERE status = 'OPEN'
       OR status = 'IN_PROCESS'.

ENDFORM.

FORM process_equipment.

  LOOP AT lt_equipment INTO ls_equipment.

* Business rule hanya berlaku untuk
* equipment yang mengalami TRIP.

    IF ls_equipment-status <> 'TRIP'.
      CONTINUE.
    ENDIF.

* Tambahan requirement:
* Notification hanya boleh dibuat apabila
* running hour melebihi 6000 jam.

    IF ls_equipment-running_hour <= 6000.
      CONTINUE.
    ENDIF.

* Cari apakah notification aktif
* sudah pernah dibuat.

    READ TABLE lt_notification
         INTO ls_notification
         WITH KEY equnr = ls_equipment-equnr.

* Jika notification aktif ditemukan,
* proses dihentikan.

    IF sy-subrc = 0.

      WRITE: / 'Skip - Active Notification Exists :',
               ls_equipment-equnr.

      CONTINUE.

    ENDIF.

* Equipment memenuhi seluruh business rule.

    PERFORM create_notification
      USING ls_equipment-equnr.

  ENDLOOP.

ENDFORM.

FORM create_notification USING iv_equnr TYPE char10.

* Simulasi proses pembuatan notification.
* Pada implementasi SAP sesungguhnya,
* bagian ini dapat diganti dengan Function Module,
* BAPI, atau Enhancement sesuai standar perusahaan.

  WRITE: / 'Create Notification :', iv_equnr.

ENDFORM.