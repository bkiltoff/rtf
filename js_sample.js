/* You need to run the script after the table is created. Just stressing it because the developer never really mentioned it the last time I looked at documentation.

Source files: */

<script type="text/javascript" src="/scripts/jquery-1.9.1.min.js"></script>

<script type="text/javascript" src="/scripts/jquery-ui-1.10.4.min.js"></script>

<link type="text/css" rel="stylesheet" href="/stylesheet/ui-lightness-1.10.4/jquery-ui-1.10.4.min.css" />

/*Fancy (not really) scripting:*/

<script type="text/javascript">
                var fixHelper = function(e, ui) {
                                ui.children().each(function() {
                                                $(this).width($(this).width());
                                                $(this).height($(this).height());
                                });
                                return ui;
                }              
                
                $("#teamwork-table tbody").sortable( 
                                { axis:"y",
                                                helper:fixHelper,
                                                update:function() {
                                                                var sorted = $("#teamwork-table tbody").sortable("toArray");
                                                                $.ajax({
                                                                                type:"post", 
                                                                                url:"/applications/teamwork/cfc/teamwork.cfc?method=updateRank", 
                                                                                data:{orderedList:sorted.join(",")} 
                                                                })
                                                }
                                });
                                
                                function updateStatus(sid,twid) {
                                                $.ajax({
                                                                type:"post",
                                                                url:"/applications/teamwork/cfc/teamwork.cfc?method=updateStatus",
                                                                data:{teamwork_id:twid,status_id:sid}
                                                });
                                }
</script>
