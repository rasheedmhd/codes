/*
|--------------------------------------------------------------------------
| Routes file
|--------------------------------------------------------------------------
|
| The routes file is used for defining the HTTP routes.
|
*/

const ServiceRequestsController = () => import('#controllers/service_requests_controller')
// import Service from '#models/service'
import router from '@adonisjs/core/services/router'
const ServicesController = () => import('#controllers/services_controller')

router.get('/', async () => {
  return {
    hello: 'world, starlet here',
  }
})

// router.get('/services', async () => {
//   // return { userName: 'Rasheed', email: 'Some@email.com' }
//   const ns = await Service.create({
//     name: 'Premium Cleaning',
//     description: 'Deep cleaning service for homes and offices',
//   })

//   // console.log(ns)
//   // const s = await Service.find(1)
//   return ns
// })

router
  .resource('/services', ServicesController)
  .apiOnly()
  .only(['index', 'show', 'store', 'update', 'destroy'])

router
  .resource('/api/service-request', ServiceRequestsController)
  .apiOnly()
  .only(['index', 'store', 'update'])
