include: "/views/bq/*.view"

# explore: transactions_bq {
#   from: transactions_bq
#   # label: "Full Transaction Analysis"
#   # Optional: Define joins here if you want to join other LookML views.
#   # Since this view is already denormalized, we will keep it simple.
# }

explore: transactions_bq {
  label: "🛍 Electronic Gadgets: Transactions & Sales"
  description: "Core explore for analyzing transactions, marketing impact, and product reviews."

  join: product_reviews_bq {
    sql_on: ${transactions_bq.productid} = ${product_reviews_bq.productid} ;;
    relationship: one_to_many
  }
  join: marketing_campaign_impact_bq {
    sql_on: ${transactions_bq.salesid} = ${marketing_campaign_impact_bq.salesid} ;;
    relationship: one_to_many
  }
}
