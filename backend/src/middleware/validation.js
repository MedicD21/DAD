import Joi from 'joi';

export const validateAnalyzeRequest = (req, res, next) => {
  const schema = Joi.object({
    url: Joi.string()
      .uri({
        scheme: ['http', 'https'],
      })
      .required()
      .messages({
        'string.uri': 'URL must be a valid HTTP or HTTPS URL',
        'any.required': 'URL is required',
      }),
  });

  const { error, value } = schema.validate(req.body);

  if (error) {
    return res.status(400).json({
      error: 'Validation failed',
      details: error.details.map(detail => ({
        message: detail.message,
        field: detail.path.join('.'),
      })),
    });
  }

  req.validatedBody = value;
  next();
};
