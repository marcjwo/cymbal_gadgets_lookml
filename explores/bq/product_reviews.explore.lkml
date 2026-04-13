include: "/views/bq/*.view"

explore: product_reviews_bq {
  # group_label: "BRK2"
  label: "AI powered product review insights"
  # Optional: Define joins here if you want to join other LookML views.
  # Since this view is already denormalized, we will keep it simple.
}
