@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Task head CDS'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZSRT_I_TASK_HEAD as select from zsrt_head_tab
{
    key task_uuid as TaskUuid,
        task_id   as Taskid,
       // title     : redirected to composition element / field? No, just alias:
        title     as Title,
        description as Description,
        overallstatus as Overallstatus
}
