const util = require('util')
const process = require('process')
const { execSync } = require('child_process')

const axios = require('axios')
const core = require('@actions/core')
const github = require('@actions/github')

async function run() {
  try {
    // Get action input variables
    const devWebhook = core.getInput('dev_webhook')
    const stagingWebhook = core.getInput('staging_webhook')
    const productionWebhook = core.getInput('production_webhook')
    const canadaWebhook = core.getInput('canada_webhook')
    const europeWebhook = core.getInput('europe_webhook')
    const include_fields = (core.getInput('include_fields') === 'true')
    const include_actions = (core.getInput('include_actions') === 'true')

    // Read git information
    const gitTag = execSync(`git tag --list --points-at HEAD`).toString().trim()
    const commitSHA = execSync(`git rev-parse --verify HEAD`).toString().trim()
    const commitMessage = execSync(`git log --oneline -n1 | cut -c9- | sed 's/\"/\\\"/g'`).toString().trim()

    // Get information about the GitHub actor/user
    const resp = await axios.get(`https://api.github.com/users/${github.context.actor}`)
    const deployerName = resp.data.name
    const deployerAvatarURL = resp.data.avatar_url

    // Debugging ...
    console.log('==================================================')
    console.log(`devWebhook: ${devWebhook}`)
    console.log(`stagingWebhook: ${stagingWebhook}`)
    console.log(`productionWebhook: ${productionWebhook}`)
    console.log(`canadaWebhook: ${canadaWebhook}`)
    console.log(`europeWebhook: ${europeWebhook}`)
    console.log(`include_fields: ${include_fields}`)
    console.log(`include_actions: ${include_actions}`)

    // Debugging ...
    console.log('==================================================')
    console.log(`gitTag: ${gitTag}`)
    console.log(`commitSHA: ${commitSHA}`)
    console.log(`commitMessage: ${commitMessage}`)

    // Debugging ...
    console.log('==================================================')
    console.log(`deployerName: ${deployerName}`)
    console.log(`deployerAvatarURL: ${deployerAvatarURL}`)

    // Debugging ...
    console.log('==================================================')
    console.log(`github.context.sha: ${github.context.sha}`)
    console.log(`github.context.ref: ${github.context.ref}`)
    console.log(`github.context.actor: ${github.context.actor}`)
    console.log(`github.context.event_name: ${github.context.event_name}`)
    console.log(`github.context.event: ${JSON.stringify(github.context.event, undefined, 2)}`)
    console.log(`github.context.repo: ${JSON.stringify(github.context.repo, undefined, 2)}`)
    console.log(`github.context.payload: ${JSON.stringify(github.context.payload, undefined, 2)}`)

    console.log('==================================================')
  } catch (err) {
    core.setFailed(err.message)
  }
}

run()
