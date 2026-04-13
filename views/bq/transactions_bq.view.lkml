view: transactions_bq {
  sql_table_name: `gemini-looker-demo-dataset.cymbal_gadgets.transactions` ;;

# --- Primary Key ---
  dimension: salesid {
    primary_key: yes
    type: number
    sql: ${TABLE}.salesid ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: total_price {
    type: number
    sql: ${TABLE}.totalprice ;;
  }

  # --- Metrics (Measures) ---
  measure: count {
    type: count
    drill_fields: [salesid, orderid, transaction_date]
  }

  measure: total_revenue {
    label: "Total Sales Revenue"
    type: sum
    sql: ${total_price} ;;
    # value_format_name: usd
    value_format: "0.000,,\" M\""
  }

  measure: total_quantity_sold {
    type: sum
    sql: ${quantity} ;;
  }

  dimension: transaction_cost {
    type: number
    sql: ${quantity} * ${product_cost} ;;
    value_format_name: usd
  }

  measure: total_cost_sold {
    type: sum
    sql: ${transaction_cost} ;;
    value_format_name: usd
  }

  dimension: transaction_margin {
    type: number
    sql: ${total_price}-${transaction_cost} ;;
    value_format_name: usd
  }

  measure: total_transaction_margin {
    sql: ${transaction_margin} ;;
    value_format_name: usd
    type: sum
  }

  measure: gross_margin_percentage {
    value_format_name: percent_2
    type: number
    sql: ${total_transaction_margin}/${total_revenue}
      ;;
  }

  measure: average_transaction_margin {
    sql: ${transaction_margin} ;;
    value_format_name: usd
    type: average
  }

  measure: average_transaction_value {
    label: "Average Transaction Value"
    type: average
    sql: ${total_price} ;;
    value_format_name: usd

  }

  # --- Transaction/Fact Columns ---
  dimension: orderid {
    type: string
    sql: ${TABLE}.orderid ;;
  }

  dimension: discount_amount {
    type: number
    sql: ${TABLE}.discountamount ;;
    value_format_name: usd
  }

  # --- Date Dimensions ---
  dimension_group: transaction {
    type: time
    datatype: date
    timeframes: [date, week, month,month_name, quarter, year, raw, week_of_year]
    sql: ${TABLE}.transaction_date ;;
  }

  dimension: calendar_year {
    type: number
    sql: ${TABLE}.year ;;
  }

  dimension: is_weekend {
    type: yesno
    sql: ${TABLE}.isweekend ;;
  }

  # --- Customer Dimensions (d_customers) ---
  dimension: customerid {
    type: number
    sql: ${TABLE}.customerid ;;
  }

  dimension: full_customer_name {
    type: string
    sql: concat(${TABLE}.firstname, ' ', ${TABLE}.lastname) ;;
  }

  dimension: customer_city {
    type: string
    sql: ${TABLE}.customer_city ;;
  }

  dimension: customer_country {
    type: string
    sql: ${TABLE}.customer_country ;;
  }

  dimension_group: customer_registration_date {
    type: time
    timeframes: [date, month]
    sql: ${TABLE}.customer_registrationdate ;;
  }

  dimension_group: between_today_and_registration {
    type: duration
    intervals: [day, month]
    sql_start:  ${customer_registration_date_date};;
    sql_end:  CURRENT_DATE() ;;
  }

  dimension_group: between_transaction_and_registration  {
    type: duration
    intervals: [day, month]
    sql_start: ${customer_registration_date_date} ;;
    sql_end: ${transaction_date} ;;
  }

  dimension: sanity_check {
    hidden: no
    type: yesno
    sql: DATE_DIFF(${transaction_date},${customer_registration_date_date}, DAY) > 1 ;;
  }

  dimension: loyalty_tier {
    type: string
    # tiers: [ "Bronze", "Silver", "Gold", "Platinum"]
    sql: ${TABLE}.loyaltytier ;;
  }

  # --- Product Dimensions (d_products) ---
  dimension: productid {
    type: number
    sql: ${TABLE}.productid ;;
  }

  dimension: productname {
    type: string
    sql: ${TABLE}.productname ;;
  }

  # dimension: product_name {
  #   type: string
  #   sql: ${TABLE}.productname ;;
  # }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  # dimension: product_category {
  #   type: string
  #   sql: ${TABLE}.category ;;
  # }

  # dimension: product_brand {
  #   type: string
  #   sql: ${TABLE}.brand ;;
  # }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: product_cost {
    type: number
    sql: ${TABLE}.product_cost ;;
    value_format_name: usd
  }

  dimension: product_master_price {
    type: number
    sql: ${TABLE}.product_product_master_price ;;
    value_format_name: usd
  }

  dimension: product_margin {
    type: number
    sql:  ${product_master_price}-${product_cost}  ;;
    value_format_name: usd
  }

  # --- Store Dimensions (d_stores) ---
  dimension: store_name {
    type: string
    sql: ${TABLE}.storename ;;
  }

  dimension: store_city {
    type: string
    sql: ${TABLE}.store_city ;;
  }

  dimension: store_region {
    type: string
    sql: ${TABLE}.store_region ;;
  }
  dimension: store_country {
    type: string
    sql: ${TABLE}.store_country ;;
  }
  dimension: store_country_1 {
    type: string
    map_layer_name: countries
    sql:
    CASE
    WHEN ${store_country} = "JP" THEN "Japan"
    WHEN ${store_country} = "US" THEN "United States"
    WHEN ${store_country} = "FR" THEN "France"
    WHEN ${store_country} = "GB" THEN "United Kingdom"
    END
    ;;
  }

  dimension: store_location {
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  # --- Channel & Payment Dimensions ---
  dimension: sales_channel_name {
    type: string
    sql: ${TABLE}.saleschannelname ;;
  }

  dimension: payment_type_name {
    type: string
    sql: ${TABLE}.paymenttypename ;;
  }

  # =====================================================================
  # --- NEW FIELDS ADDED FROM 'NEW' FILE ---
  # =====================================================================

  dimension: storeid {
    hidden: yes
    type: number
    sql: ${TABLE}.storeid ;;
  }

  dimension: firstname {
    hidden: yes
    type: string
    sql: ${TABLE}.firstname ;;
  }

  dimension: lastname {
    hidden: yes
    type: string
    sql: ${TABLE}.lastname ;;
  }

  dimension: shippingcost {
    hidden: yes
    type: number
    sql: ${TABLE}.shippingcost ;;
  }

  dimension: taxamount {
    hidden: yes
    type: number
    sql: ${TABLE}.taxamount ;;
  }

  dimension: gross_profit {
    group_label: "Financials"
    label: "Gross Profit"
    description: "Total Price minus Product Cost"
    type: number
    value_format_name: usd
    sql: ${total_price} - (${product_cost} * ${quantity}) ;;
  }

  measure: total_gross_profit {
    label: "Total Gross Profit"
    description: "Sum of gross profit across all transactions."
    type: sum
    sql: ${gross_profit} ;;
    value_format_name: usd_0
    drill_fields: [transaction_details*]
  }

  measure: average_order_value {
    label: "Average Order Value (AOV)"
    description: "Average revenue generated per transaction."
    type: average
    sql: ${total_price} ;;
    value_format_name: usd
  }

  measure: unique_customers {
    label: "Total Unique Customers"
    type: count_distinct
    sql: ${customerid} ;;
  }

  set: transaction_details {
    fields: [
      transaction_date,
      full_customer_name,
      store_name,
      productname,
      category,
      sales_channel_name,
      quantity,
      total_revenue
    ]
  }
  dimension: shipment_id {
    type: string
    sql: ${TABLE}.shipmentid ;;
    group_label: "Logistics"
    description: "Unique Identifier for the shipment"
  }
  dimension: shipping_method {
    type: string
    sql: ${TABLE}.shippingmethod ;;
    group_label: "Logistics"
  }
  dimension: shipment_status {
    type: string
    sql: ${TABLE}.shipment_status ;;
    group_label: "Logistics"
  }
  dimension_group: estimated_delivery {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.estimateddeliverydate ;;
    group_label: "Logistics"
  }
  dimension_group: actual_delivery {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.actualdeliverydate ;;
    group_label: "Logistics"
  }
  # Calculated Dimension: Was it delayed?
  dimension: is_delayed {
    type: yesno
    sql: ${TABLE}.actualdeliverydate > ${TABLE}.estimateddeliverydate ;;
    group_label: "Logistics"
    description: "Yes if Actual Delivery Date is after Estimated Delivery Date"
  }
  # Calculated Dimension: Days Delayed
  dimension: delay_days {
    type: number
    sql: DATE_DIFF(${TABLE}.actualdeliverydate, ${TABLE}.estimateddeliverydate, DAY) ;;
    group_label: "Logistics"
  }
  # ==========================================
  # 🏢 DISTRIBUTION CENTER
  # ==========================================
  dimension: distribution_center_name {
    type: string
    sql: ${TABLE}.distribution_center_name ;;
    group_label: "Distribution Center"
  }
  dimension: distribution_center_city {
    type: string
    sql: ${TABLE}.distribution_center_city ;;
    group_label: "Distribution Center"
  }
  dimension: distribution_center_state {
    type: string
    sql: ${TABLE}.distribution_center_state ;;
    group_label: "Distribution Center"
  }
  dimension: distribution_center_country {
    type: string
    sql: ${TABLE}.distribution_center_country ;;
    group_label: "Distribution Center"
  }
  # Rich Location Type for Map Visualizations
  dimension: distribution_center_location {
    type: location
    sql_latitude: ${TABLE}.distribution_center_latitude ;;
    sql_longitude: ${TABLE}.distribution_center_longitude ;;
    group_label: "Distribution Center"
  }
  # ==========================================
  # 📈 LOGISTICS METRICS (MEASURES)
  # ==========================================
  measure: count_shipments {
    type: count_distinct
    sql: ${shipment_id} ;;
    group_label: "Logistics Metrics"
  }
  measure: count_delayed_shipments {
    type: count
    filters: [is_delayed: "Yes"]
    group_label: "Logistics Metrics"
  }
  measure: average_delay_days {
    type: average
    sql: ${delay_days} ;;
    value_format_name: decimal_1
    group_label: "Logistics Metrics"
  }
  measure: percent_delayed {
    type: number
    sql: 1.0 * ${count_delayed_shipments} / NULLIF(${count_shipments}, 0) ;;
    value_format_name: percent_1
    group_label: "Logistics Metrics"
    description: "Percentage of shipments that arrived after their estimated date"
  }
}

# view: sales {
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
