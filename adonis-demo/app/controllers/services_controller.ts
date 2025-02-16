import type { HttpContext } from '@adonisjs/core/http'
import Service from '#models/service'
// import { joiErrorsToResponse } from '#validators/common'
// import { createServiceValidator } from '../validators/service'

import Joi from 'joi'
import { createServiceValidator, updateServiceValidator } from '#validators/service'

export const listServiceValidator = Joi.object({
  name: Joi.string().max(250).optional(),
  description: Joi.string().optional().max(1000),
  limit: Joi.number().default(50),
  page: Joi.number().default(1),
})

export const joiErrorsToResponse = (error: Joi.ValidationError, status: number = 400) => {
  return {
    status,
    errors: Object.fromEntries(error.details.map((e) => [e.path.join('.'), e.message])),
  }
}

export const pinValidator = Joi.string().min(5).required()

export const emailValidator = Joi.string().lowercase().email().required()

export const searchValidator = Joi.object({
  search: Joi.string().required().min(3),
})

export const defaultJoiValidationOpts = {
  abortEarly: false,
}

// TO DO: Test that update with non unique name fails at
// the db level

export default class ServicesController {
  async index(ctx: HttpContext) {
    const { error, value } = listServiceValidator.validate(ctx.request.qs(), {
      abortEarly: false,
    })
    if (error) return ctx.response.status(400).json(joiErrorsToResponse(error))
    const services = await Service.query()
      .orderBy('createdAt', 'desc')
      .paginate(value.page, value.limit)
    return ctx.response.status(200).json({
      status: 200,
      data: services,
    })
  }
  async store(ctx: HttpContext) {
    const { error, value } = createServiceValidator.validate(ctx.request.body(), {
      abortEarly: false,
    })

    if (error) return ctx.response.status(400).send(joiErrorsToResponse(error))
    const service = await Service.create(value)
    return ctx.response.status(201).send({
      status: 201,
      data: service,
    })
  }

  // To Do, fix bc it doesn't work at the moment and it is not part of the issue
  async show(ctx: HttpContext) {
    console.log(ctx.request.params())
    console.log(ctx.request)
    const service = await Service.findByOrFail({ id: ctx.request.params().id })
    return ctx.response.status(200).send({
      status: 200,
      data: service,
    })
  }
  async update(ctx: HttpContext) {
    const { error, value } = updateServiceValidator.validate(ctx.request.body(), {
      abortEarly: false,
    })
    if (error) return ctx.response.status(400).send(joiErrorsToResponse(error))
    const service = await Service.findByOrFail({ id: ctx.request.params().id })

    // TO DO: Test that update with non unique name fails at
    // the db level
    if (value.name) {
      const serviceExists = await Service.query()
        .where('name', value.name)
        .whereNot('id', service.id)
        .first()

      if (serviceExists) {
        return ctx.response.status(400).json({
          status: 400,
          error: ['E_SERVICE_NAME_EXIST_ALREADY'],
        })
      }

      service.merge(value)
      await service.save()
      return ctx.response.status(201).send({
        status: 201,
        data: service,
      })
    }
  }
}
