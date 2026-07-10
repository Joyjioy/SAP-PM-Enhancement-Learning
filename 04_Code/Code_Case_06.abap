REPORT zcase06_final_enhancement.

TYPES: BEGIN OF ty_equipment,
         equnr         TYPE char10,
         status        TYPE char20,
         running_hour  TYPE i,
       END OF ty_equipment.

TYPES: BEGIN OF ty_notification,
         equnr         TYPE char10,
         status        TYPE char20,
       END OF ty_notification.

TYPES: BEGIN OF ty_permit,
         equnr          TYPE char10,
         permit_status  TYPE char20,
       END OF ty_permit.

DATA: lt_equipment    TYPE TABLE OF ty_equipment,
      lt_notification TYPE TABLE OF ty_notification,
      lt_permit       TYPE TABLE OF ty_permit,
      ls_equipment    TYPE ty_equipment,
      ls_notification TYPE ty_notification,
      ls_permit       TYPE ty_permit.

START-OF-SELECTION.

* Ambil seluruh data yang diperlukan sebelum
* menjalankan business rule.

  PERFORM get_data.

* Jalankan validasi terhadap setiap equipment.

  PERFORM process_equipment.

FORM get_data.

* Ambil data equipment.

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

* Ambil data permit.

  SELECT equnr
         permit_status
    FROM zpermit
    INTO TABLE lt_permit.

ENDFORM.

FORM process_equipment.

  LOOP AT lt_equipment INTO ls_equipment.

* Validasi status equipment.

    IF ls_equipment-status <> 'TRIP'.
      CONTINUE.
    ENDIF.

* Validasi running hour.

    IF ls_equipment-running_hour <= 6000.
      CONTINUE.
    ENDIF.

* Validasi permit.

    READ TABLE lt_permit
         INTO ls_permit
         WITH KEY equnr = ls_equipment-equnr.

    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.

    IF ls_permit-permit_status <> 'APPROVED'.
      CONTINUE.
    ENDIF.

* Validasi notification aktif.

    READ TABLE lt_notification
         INTO ls_notification
         WITH KEY equnr = ls_equipment-equnr.

    IF sy-subrc = 0.
      CONTINUE.
    ENDIF.

* Seluruh business rule telah terpenuhi.

    PERFORM create_notification
      USING ls_equipment-equnr.

  ENDLOOP.

ENDFORM.

FORM create_notification USING iv_equnr TYPE char10.

* Simulasi pembuatan Notification.
* Pada implementasi SAP sebenarnya,
* bagian ini dapat diganti dengan
* Function Module, BAPI, atau Enhancement.

  WRITE: / 'Create Notification :', iv_equnr.

ENDFORM.