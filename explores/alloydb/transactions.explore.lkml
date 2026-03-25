include: "/views/alloydb/*.view"
explore: transactions {
  label: "Global Gadgets Transactions - AlloyDB"
  group_label: "BRK2"
  description: "This explore is based on Global Gadgets transactions hosted on AlloyDB - its enriched with products and stores data to deliver insights from that angle."
  from: f_transactions
  # sql_always_where: ${storeid} is not NULL ;;
  join: d_dates {
    sql_on: ${transactions.datekey} = ${d_dates.datekey} ;;
    relationship: one_to_one
  }
  join: d_stores {
    sql_on: ${transactions.storeid} = ${d_stores.storeid} ;;
    relationship: many_to_one
  }
  join: d_products {
    sql_on: ${transactions.productid} = ${d_products.productid} ;;
    relationship: many_to_one
  }
  join: d_customers {
    sql_on: ${transactions.customerid} = ${d_customers.customerid} ;;
    relationship: many_to_one
    sql_where: ${transactions.customerid} is NOT NULL ;;
  }
  join: d_saleschannels {
    sql_on: ${transactions.saleschannelid} = ${d_saleschannels.saleschannelid} ;;
    relationship: many_to_one
  }
}
