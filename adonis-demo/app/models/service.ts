import { column } from '@adonisjs/lucid/orm'
import Base from '#models/base'

export default class Service extends Base {
  @column()
  declare name: string

  @column()
  declare description: string | null
}
