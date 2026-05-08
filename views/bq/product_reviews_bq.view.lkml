view: product_reviews_bq {
  sql_table_name: `gemini-looker-demo-dataset.cymbal_gadgets.product_reviews` ;;
#   derived_table: {
#     datagroup_trigger: bq_refresh
#     sql:
# SELECT
#     t.reviewid,
#     t.productid,
#     t.reviewername,
#     t.rating,
#     t.reviewtext,
#     t.reviewdate,
#     t.productname
# FROM
#     EXTERNAL_QUERY('gemini-looker-demo-dataset.us.global_gadgets_alloydb', '''
#         SELECT
#             pr.reviewid,
#             pr.productid,
#             pr.reviewername,
#             pr.rating,
#             pr.reviewtext,
#             pr.reviewdate,
#             p.productname
#         FROM
#             d_productreviews pr
#         INNER JOIN d_products p ON pr.productid = p.productid
#     ''') AS t;;
#   }
# --- Primary Key (for review) ---
  dimension: reviewid {
    primary_key: yes
    type: number
    sql: ${TABLE}.reviewid ;;
  }

  dimension: productid {
    # This is the foreign key for joining to the product/transaction view
    type: number
    sql: ${TABLE}.productid ;;
  }

  dimension: productname {
    type: string
    sql: ${TABLE}.productname ;;
    # drill_fields: [review_score,review_text]
  }

  dimension: reviewer_name {
    type: string
    sql: ${TABLE}.reviewername ;;
  }

  dimension: rating {
    type: number
    sql: ${TABLE}.rating ;;
  }

  measure: average_rating {
    type: average
    sql: ${rating} ;;
    drill_fields: [review_text]
  }

  dimension: review_text {
    type: string
    sql: ${TABLE}.reviewtext ;;
  }

  dimension_group: review_date {
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.reviewdate ;;
    datatype: date
  }

  # --- Measures on the Review Table itself ---
  measure: review_count_raw {
    type: count
    label: "Total Raw Review Count"
  }

  ### AI FUNCTIONS BIGQUERY

  dimension: review_score {
    group_label: "BQ AI"
    sql: AI.SCORE(("Rate sentiment 1-10:", ${review_text}),
    connection_id => 'us.vertex_ai_connection_bq_functions') ;;
  }

  dimension: semantic_search {
    type: string
    group_label: "BQ AI"
    # sql: CASE
    #       WHEN AI.IF(("Talks about battery life:",${review_text}),connection_id => 'us.vertex_ai_connection_bq_functions')
    #       THEN "Yes"
    #       ELSE "No"
    #       END ;;
    sql: CASE
    WHEN AI.IF(({% parameter semantic_search_parameter %},${review_text}),connection_id => 'us.vertex_ai_connection_bq_functions')
    THEN "Yes"
    ELSE "No"
    END ;;
  }

  parameter: semantic_search_parameter {
    group_label: "BQ AI"
    type: string

  }

  ###

}

# view: product_reviews {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
