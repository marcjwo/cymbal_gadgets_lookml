view: d_distribution_centers {
  fields_hidden_by_default: yes
  view_label: "Distribution Centers"
  sql_table_name: public.d_distribution_centers ;;

  dimension: capacity {
    hidden: yes
    type: number
    sql: ${TABLE}."capacity" ;;
  }
  dimension: city {
    hidden: no
    type: string
    sql: ${TABLE}."city" ;;
  }
  dimension: country {
    hidden: no
    type: string
    map_layer_name: countries
    sql: ${TABLE}."country" ;;
  }
  dimension: distributioncenterid {
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}."distributioncenterid" ;;
  }
  dimension: latitude {
    hidden: yes
    type: number
    sql: ${TABLE}."latitude" ;;
  }
  dimension: longitude {
    hidden: yes
    type: number
    sql: ${TABLE}."longitude" ;;
  }

  dimension: location {
    label: "Distribution Center Location"
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }
  dimension: name {
    hidden: no
    type: string
    sql: ${TABLE}."name" ;;
  }
  dimension: state {
    hidden: yes
    type: string
    sql: ${TABLE}."state" ;;
  }
  measure: count {
    hidden: yes
    type: count
    drill_fields: [name]
  }
}
