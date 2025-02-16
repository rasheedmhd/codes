import Service from '#models/service'
import { ServiceRequestStatus } from '#models/service_request'
// import Visitation from '#models/visitation'
import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'service_requests'

  async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.increments('id')
      table
        .integer('visitation_id')
        .notNullable()
        .unsigned()
        .references('id')
        .inTable(Service.table)
        .onDelete('CASCADE')
      table
        .integer('service_id')
        .notNullable()
        .unsigned()
        .references('id')
        .inTable(Service.table)
        .onDelete('CASCADE')
      table
        .enum('status', Object.values(ServiceRequestStatus))
        .notNullable()
        .defaultTo(ServiceRequestStatus.PENDING)
      table.timestamp('created_at')
      table.timestamp('updated_at')
    })
  }

  async down() {
    this.schema.dropTable(this.tableName)
  }
}
