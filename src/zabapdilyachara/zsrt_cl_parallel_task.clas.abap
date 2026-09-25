class zsrt_cl_parallel_task definition
public
final
create public.

public section.
   interfaces if_serializable_object.
   interfaces if_abap_parallel.

methods :
   constructor importing iv_material TYPE string,
   get_result returning value(rt_result) type string.

private section.
data: mv_material type string.
data: mv_result type string.


ENDCLASS.



CLASS ZSRT_CL_PARALLEL_TASK IMPLEMENTATION.


   method constructor.
       mv_material = iv_material.
   endmethod.


   method get_result.
       return mv_result.
   endmethod.


   method if_abap_parallel~do.
      data: lt_task_create type table for create zsrt_i_task_head,
            ls_task_create like line of lt_task_create,
            lt_reported type response for reported early zsrt_i_task_head,
            lt_mapped   type response for mapped early zsrt_i_task_head,
            lt_failed TYPE RESPONSE for failed early zsrt_i_task_head.

      lt_task_create = VALUE #(
       (
        %cid = 'MY_CID_1'
        taskid = |TASK-{ mv_material }|
        title = |New task for { mv_material }|
        description = 'Test Description'
        overallstatus = 'O'
        %control = VALUE #(
        TASKID = if_abap_behv=>mk-on
        title = if_abap_behv=>mk-on
        description = if_abap_behv=>mk-on
        overallstatus = if_abap_behv=>mk-on )
       )
      ).


      MODIFY ENTITIES OF ZSRT_I_TASK_HEAD
      ENTITY ZSRT_I_TASK_HEAD
      CREATE FROM lt_task_create
      MAPPED lt_mapped
      FAILED lt_failed
      REPORTED lt_reported.

      IF lt_failed is initial.
        commit entities.

        read table lt_mapped-zsrt_i_task_head into data(ls_map) INDEX 1.

        if sy-subrc = 0.
           mv_result = ls_map-TaskUuid.
        endif.
      endif.

   endmethod.
ENDCLASS.
