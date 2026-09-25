CLASS ZSRT_CL_PROCESS DEFINITION
PUBLIC
FINAL
CREATE PUBLIC.

     PUBLIC SECTION.
           interfaces if_oo_adt_classrun.

     PROTECTED SECTION.

     PRIVATE SECTION.

ENDCLASS.



CLASS ZSRT_CL_PROCESS IMPLEMENTATION.


      METHOD: if_oo_adt_classrun~main.

          Data: lt_process type cl_abap_parallel=>t_in_inst_tab,
                lt_results TYPE table of sysuuid_x16.


          select * from zsrt_i_bill_item into table @data(lt_item).

          LOOP AT lt_item into data(ls_item).

               insert new zsrt_cl_parallel_task(
                      CONV #( ls_item-Materialid )
                ) into table lt_process.

          endloop.

           new cl_abap_parallel( p_num_tasks = 5 )->run_inst(
                 exporting
                     p_in_tab  = lt_process
                 importing
                     p_out_tab = data(lt_function)

           ).

           LOOP AT lt_function into data(ls_finished).

               data(lv_uuid) = cast zsrt_cl_parallel_task(
                     ls_finished-inst
               )->get_result( ).

               append lv_uuid to lt_results.

           endloop.


           data: idx type sy-index.
           idx = 0.

           loop at lt_item into ls_item.

              idx = idx + 1.

              READ table lt_results into data(ls_result) index idx.

              modify entities of zsrt_i_bill_item
                entity zsrt_i_bill_item
                update from value #(
                   (
                      %cid_ref = 'MY_CID_1'
                      billid = ls_item-billid
                      materialid = ls_item-Materialid
                      itemno = ls_item-itemno
                      description = ls_result
                      %control = value #(
                          billid = if_abap_behv=>mk-on
                          materialid = if_abap_behv=>mk-on
                          itemno     = if_abap_behv=>mk-on
                          description = if_abap_behv=>mk-on
                      )
                    )
                 ).

           endloop.
      endmethod.
ENDCLASS.
