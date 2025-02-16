import Joi from 'joi'

export const pageOptionsValidator = Joi.object({
  page: Joi.number().default(1).min(1),
  limit: Joi.number().default(10).max(25).min(5),
  sort: Joi.string().default('fullName'),
  sortDirection: Joi.string().default('asc'),
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
