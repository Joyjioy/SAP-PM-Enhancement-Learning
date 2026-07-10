REPORT zcase05_create_workorder.

TYPES: BEGIN OF ty_notification,
         notif_no TYPE char10,
         status   TYPE char20,
       END OF ty_notification.

TYPES: BEGIN OF ty_workorder,
         wo_no    TYPE char10,
         notif_no TYPE char10,
       END OF ty_workorder.

DATA: lt_notification TYPE TABLE OF ty_notification,
      lt_workorder    TYPE TABLE OF ty_workorder,
      ls_notification TYPE ty_notification,
      ls_workorder    TYPE ty_workorder.

START-OF-SELECTION.

* Ambil data Notification dan Work Order.
  PERFORM get_data.

* Jalankan enhancement pembuatan Work Order.
  PERFORM process_notification.

FORM get_data.

* Hanya Notification yang masih aktif
* yang perlu diperiksa.

  SELECT notif_no
         status
    FROM znotification
    INTO TABLE lt_notification
    WHERE status = 'OPEN'
       OR status = 'IN_PROCESS'.

* Ambil seluruh Work Order yang sudah ada.

  SELECT wo_no
         notif_no
    FROM zworkorder
    INTO TABLE lt_workorder.

ENDFORM.

FORM process_notification.

  LOOP AT lt_notification INTO ls_notification.

* Periksa apakah Notification sudah
* memiliki Work Order.

    READ TABLE lt_workorder
         INTO ls_workorder
         WITH KEY notif_no = ls_notification-notif_no.

* Jika Work Order sudah ada,
* lanjutkan ke Notification berikutnya.

    IF sy-subrc = 0.

      WRITE: / 'Skip - Work Order Exists :',
               ls_notification-notif_no.

      CONTINUE.

    ENDIF.

* Notification belum memiliki Work Order.

    PERFORM create_workorder
      USING ls_notification-notif_no.

  ENDLOOP.

ENDFORM.

FORM create_workorder USING iv_notif_no TYPE char10.

* Simulasi proses pembuatan Work Order.
* Pada implementasi SAP sebenarnya,
* bagian ini dapat diganti dengan
* Function Module atau BAPI.

  WRITE: / 'Create Work Order :', iv_notif_no.

ENDFORM.