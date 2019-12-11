const path = require('path')
const process = require('process')
const { exec } = require('child_process')

describe('run', () => {
  beforeEach(() => {
  })

  afterEach(() => {
  })

  test('', done => {
    const env = Object.assign({}, process.env, {
      GITHUB_SHA: '',
      GITHUB_REF: '',
      GITHUB_ACTOR: 'moorara',
      GITHUB_REPOSITORY: '',
      GITHUB_EVENT_PATH: '',

      INPUT_WEBHOOK: '',
      INPUT_ENVIRONMENT: '',
      INPUT_REGION: '',
      INPUT_ARTIFACT: '',
      INPUT_VERSION: '',
      INPUT_INCLUDE_FIELDS: '',
      INPUT_INCLUDE_ACTIONS: ''
    })

    const fp = path.join(__dirname, 'index.js')
    exec(`node ${fp}`, { env }, (err, stdout, stderr) => {
      console.log(`${stdout}`)
      console.log(`${stderr}`)
      expect(err).toBeNull()
      done()
    })
  })
})
