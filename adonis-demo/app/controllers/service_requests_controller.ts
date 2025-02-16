import ServiceRequest from '#models/service_request'
import { joiErrorsToResponse } from '#validators/common'
import {
  createServiceRequestValidator,
  listServiceRequestsValidator,
  updateServiceRequestValidator,
} from '#validators/service_request'
import type { HttpContext } from '@adonisjs/core/http'

export default class ServiceRequestsController {
  async index({ request, response }: HttpContext) {
    const { error, value } = listServiceRequestsValidator.validate(request.qs(), {
      abortEarly: false,
    })

    if (error) return response.status(400).json(joiErrorsToResponse(error))
    const services = await ServiceRequest.query()
      .orderBy('updatedAt', 'desc')
      .paginate(value.page, value.limit)
    return response.status(200).json({
      status: 200,
      data: services,
    })
  }

  async store({ request, response }: HttpContext) {
    const { error, value } = createServiceRequestValidator.validate(request.body(), {
      abortEarly: false,
    })

    if (error) return response.status(400).send(joiErrorsToResponse(error))
    const service = await ServiceRequest.create(value)
    return response.status(201).send({
      status: 201,
      data: service,
    })
  }

  async update({ request, response }: HttpContext) {
    const { error, value } = updateServiceRequestValidator.validate(request.body(), {
      abortEarly: false,
    })

    if (error) return response.status(400).send(joiErrorsToResponse(error))
    const serviceRequest = await ServiceRequest.findByOrFail({ id: request.params().id })

    serviceRequest.merge(value)
    await serviceRequest.save()
    return response.status(201).send({
      status: 201,
      data: serviceRequest,
    })
  }
}
