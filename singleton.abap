*&---------------------------------------------------------------------*
*& Report YTESTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yteste.


*CLASS local DEFINITION .
*
*  PUBLIC SECTION .
*
*    CLASS-METHODS set .
*
*    CLASS-METHODS get .
*
*ENDCLASS .
*
*CLASS local IMPLEMENTATION .
*
*  METHOD set .
*    DATA:
*      x TYPE char5,
*      y TYPE char5 value '#I#'.
*
*    EXPORT y FROM x TO MEMORY ID 'xyz'.
*  ENDMETHOD .
*
*  METHOD get .
*    DATA:
*      x TYPE char5,
*      y TYPE char5.
*    IMPORT x TO y FROM MEMORY ID 'xyx'.
*
*  ENDMETHOD .
*
*ENDCLASS .
*
*INITIALIZATION .
*
*  local=>set( ) .
*  local=>get( ) .

*
*----------------------------------------------------------------------*
*       CLASS lcl_application DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_application DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.

*   Static Method which will return us the object reference
    CLASS-METHODS get_apps_instance
      RETURNING
        VALUE(ro_apps) TYPE REF TO lcl_application.

    METHODS set_internal_name
      IMPORTING
        iv_name TYPE char30 .
    METHODS get_internal_name
      RETURNING
        VALUE(rv_name) TYPE char30.

  PRIVATE SECTION.

*   static class reference to hold the existing object reference
    CLASS-DATA:
      internal_object TYPE REF TO lcl_application.

    DATA:
      internal_name TYPE char30 .

ENDCLASS.                    "lcl_application DEFINITION


*----------------------------------------------------------------------*
*       CLASS lcl_application IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_application IMPLEMENTATION.

* This method will return the object reference to the calling application
  METHOD get_apps_instance.
    IF internal_object IS INITIAL.
*     creation of the object
      CREATE OBJECT internal_object.
    ENDIF.
*   assigning reference back to exporting parameter
    ro_apps = internal_object.
  ENDMETHOD.                    "get_apps_instance


  METHOD set_internal_name.
    me->internal_name = iv_name.
  ENDMETHOD.                    "set_v_name


  METHOD get_internal_name.
    rv_name = me->internal_name.
  ENDMETHOD.                    "get_v_name


ENDCLASS.                    "lcl_application IMPLEMENTATION
*
*
START-OF-SELECTION.
*
*.Reference: 1 .........................................
  DATA: lo_application TYPE REF TO lcl_application.
  DATA: lv_result TYPE char30.
*
  WRITE: / 'LO_APPLICATION: '.
* calling the method which gets us the instance
* Statement CREATE OBJECT LO_APPLICATION
* would not work as the class LCL_APPLICATION instantiation
* is set to PRIVATE
  lo_application = lcl_application=>get_apps_instance( ).
* Set the variable and get it back.
  lo_application->set_internal_name( 'This is first Object' ).
  lv_result = lo_application->get_internal_name( ).
  WRITE: / lv_result.
  CLEAR lv_result.
*
*.Reference: 2............................................
  DATA: lo_2nd_apps TYPE REF TO lcl_application.
  SKIP 2.
  WRITE: / 'LO_2ND_APPS : '.
*   calling the method which gets us the instance
* By calling GET_APPS_INSTANCE method again to get the singleton
* object, it would give the same object back and assign it to
* LO_2ND_APPS object reference. This would be varified by
* getting the value of the instance attribute V_NAME
  lo_2nd_apps = lcl_application=>get_apps_instance( ).
  lv_result = lo_2nd_apps->get_internal_name( ).
  WRITE: / lv_result.
  CLEAR lv_result.
