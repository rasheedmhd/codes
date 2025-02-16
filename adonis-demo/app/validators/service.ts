import Joi from 'joi'

export const createServiceValidator = Joi.object({
  name: Joi.string().max(250).required(),
  description: Joi.string().optional().max(1000),
})

export const updateServiceValidator = Joi.object({
  name: Joi.string().max(250).optional(),
  description: Joi.string().optional().max(1000),
})
