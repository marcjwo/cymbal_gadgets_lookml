connection: "default_bigquery_connection"
include: "/dashboards/cymbal_gadgets.dashboard.lookml"
# include: "/views/bq/*.view.lkml"
include: "/explores/bq/*.explore.lkml"
# include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

datagroup: bq_refresh {
  sql_trigger:
  SELECT
*
FROM
    EXTERNAL_QUERY('gemini-looker-demo-dataset.us.global_gadgets_alloydb', '''
SELECT count(*) FROM
  "public"."v_transactions";
  ''')
    ;;
}
