view: f_shipments {
  view_label: "Shipments"
  fields_hidden_by_default: yes
  sql_table_name: public.f_shipments ;;

  dimension_group: actualdeliverydate {
    hidden: no
    label: "Acutal Delivery"
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."actualdeliverydate" ;;
  }
  dimension: distributioncenterid {
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}."distributioncenterid" ;;
  }
  dimension_group: estimateddeliverydate {
    label: "Estimated Delivery"
    hidden: no
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."estimateddeliverydate" ;;
  }
  dimension: orderid {
    hidden: yes
    type: string
    sql: ${TABLE}."orderid" ;;
  }
  dimension: shipmentid {
    hidden: yes
    type: string
    sql: ${TABLE}."shipmentid" ;;
  }
  dimension: shippingcost {
    hidden: yes
    type: number
    sql: ${TABLE}."shippingcost" ;;
  }
  dimension: shippingmethod {
    hidden: no
    type: string
    sql: ${TABLE}."shippingmethod" ;;
  }
  dimension: status {
    hidden: no
    type: string
    sql: ${TABLE}."status" ;;
  }
  measure: count {
    hidden: yes
    type: count
  }
}
