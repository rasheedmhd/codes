import { column } from '@adonisjs/lucid/orm'
import Base from '#models/base'

export enum ServiceRequestStatus {
  PENDING = 'pending',
  PAID = 'paid',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled',
}

export default class ServiceRequest extends Base {
  @column()
  declare status: ServiceRequestStatus

  @column()
  declare visitId: number

  @column()
  declare serviceId: number
}
