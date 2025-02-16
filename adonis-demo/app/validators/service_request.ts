import Joi from 'joi'
import { ServiceRequestStatus } from '#models/service_request'

export const createServiceRequestValidator = Joi.object({
  visitation_id: Joi.number().integer().positive().required(),
  service_id: Joi.number().integer().positive().required(),
  status: Joi.string()
    .valid(...Object.values(ServiceRequestStatus))
    .default(ServiceRequestStatus.PENDING),
})

export const updateServiceRequestValidator = Joi.object({
  visitation_id: Joi.number().integer().positive().optional(),
  service_id: Joi.number().integer().positive().optional(),
  status: Joi.string()
    .valid(...Object.values(ServiceRequestStatus))
    .optional(),
})

export const listServiceRequestsValidator = Joi.object({
  visitation_id: Joi.number().integer().positive().optional(),
  service_id: Joi.number().integer().positive().optional(),
  status: Joi.string()
    .valid(...Object.values(ServiceRequestStatus))
    .optional(),
  limit: Joi.number().integer().min(1).default(10),
  page: Joi.number().integer().min(1).default(1),
})
