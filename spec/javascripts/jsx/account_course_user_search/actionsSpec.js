/*
 * Copyright (C) 2015 - present Instructure, Inc.
 *
 * This file is part of Canvas.
 *
 * Canvas is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, version 3 of the License.
 *
 * Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import actions from 'jsx/account_course_user_search/actions/UserActions'
import UserStore from 'jsx/account_course_user_search/UsersStore'

const STUDENTS = [
  {
    id: '46',
    name: 'Irene Adler',
    sortable_name: 'Adler, Irene',
    short_name: 'Irene Adler',
    sis_user_id: '957',
    integration_id: null,
    sis_login_id: 'student57',
    sis_import_id: '1',
    login_id: 'student57',
    email: 'brotherhood@example.com',
    last_login: null,
    time_zone: 'Mountain Time (US & Canada)'
  },
  {
    id: '44',
    name: 'Saint-John Allerdyce',
    sortable_name: 'Allerdyce, Saint-John',
    short_name: 'Saint-John Allerdyce',
    sis_user_id: '955',
    integration_id: null,
    sis_login_id: 'student55',
    sis_import_id: '1',
    login_id: 'student55',
    email: 'brotherhood@example.com',
    last_login: null,
    time_zone: 'Mountain Time (US & Canada)'
  },
  {
    id: '52',
    name: 'Michael Baer',
    sortable_name: 'Baer, Michael',
    short_name: 'Michael Baer',
    sis_user_id: '963',
    integration_id: null,
    sis_login_id: 'student63',
    sis_import_id: '1',
    login_id: 'student63',
    email: 'marauders@example.com',
    last_login: null,
    time_zone: 'Mountain Time (US & Canada)'
  }
]

QUnit.module('Account Course User Search Actions')

test('apiCreateUser', function(assert) {
  assert.expect(3)
  const server = sinon.fakeServer.create()
  UserStore.reset({accountId: 1})

  server.respondWith('POST', '/api/v1/accounts/1/users', [
    200,
    {'Content-Type': 'application/json'},
    JSON.stringify(STUDENTS[0])
  ])

  equal(typeof actions.apiCreateUser(1, {}), 'function', 'it initally returns a callback function')

  actions.apiCreateUser(1, {})(response => {
    equal(response.type, 'ADD_TO_USERS', 'it dispatches the proper action')
    equal(Array.isArray(response.payload.users), true, 'it returns a users array')
  })

  server.respond()
  server.restore()
})

test('addError', () => {
  const message = actions.addError({errorKey: 'error'})
  equal(message.type, 'ADD_ERROR', 'it returns the proper action type')
  deepEqual(message.error, {errorKey: 'error'}, 'it returns the proper error')
})

asyncTest('apiUpdateUser', () => {
  const server = sinon.fakeServer.create()

  // This is a POST rather than a PUT because of the way our $.getJSON converts
  // non-GET requests to posts anyways.
  server.respondWith('POST', /api\/v1\/users\/1/, [
    200,
    {'Content-Type': 'application/json'},
    JSON.stringify(STUDENTS[0])
  ])

  equal(
    typeof actions.apiUpdateUser({name: 'Test'}, 1),
    'function',
    'it initally returns a callback function'
  )

  actions.apiUpdateUser({name: 'Test'}, 1)(response => {
    equal(response.type, 'GOT_USER_UPDATE', 'it returns the proper action type')
    deepEqual(response.payload, STUDENTS[0], 'it returns the user in the payload')
    start()
  })

  server.respond()
  server.restore()
})

test('openEditUserDialog', () => {
  const message = actions.openEditUserDialog(STUDENTS[0])
  equal(message.type, 'OPEN_EDIT_USER_DIALOG', 'it returns the proper type')
  deepEqual(message.payload, STUDENTS[0], 'the payload contains the user')
})

test('closeEditUserDialog', () => {
  const message = actions.closeEditUserDialog(STUDENTS[0])
  equal(message.type, 'CLOSE_EDIT_USER_DIALOG', 'it returns the proper type')
  deepEqual(message.payload, STUDENTS[0], 'the payload contains the user')
})

test('updateSearchFilter', () => {
  const message = actions.updateSearchFilter('myFilter')
  equal(message.type, 'UPDATE_SEARCH_FILTER', 'it returns the proper type')
  equal(message.payload, 'myFilter', 'the payload contains the filter')
})

test('displaySearchTermTooShortError', () => {
  const message = actions.displaySearchTermTooShortError(3)
  equal(message.type, 'SEARCH_TERM_TOO_SHORT', 'it returns the proper type')
  equal(
    message.errors.termTooShort,
    'Search term must be at least 3 characters',
    'the error is set with the proper number'
  )
})

test('loadingUsers', () => {
  const message = actions.loadingUsers()
  equal(message.type, 'LOADING_USERS', 'it returns the proper type')
})

asyncTest('applySearchFilter', () => {
  let count = 3
  const done = () => {
    --count || start()
  }

  const fakeDispatcherSearchLengthOkay = response => {
    if (count === 3) {
      equal(response.type, 'LOADING_USERS', 'it returns the proper action type')
      done()
    } else {
      equal(response.type, 'GOT_USERS', 'it returns the proper action type')
      deepEqual(response.payload.users[0], STUDENTS[0], 'it returns the user in the payload')
      done()
    }
  }

  const fakeGetStateSearchLengthOkay = () => ({
    userList: {
      searchFilter: {
        search_term: 'abcd'
      }
    }
  })

  const fakeDispatcherSearchLengthTooShort = response => {
    equal(response.type, 'SEARCH_TERM_TOO_SHORT', 'it returns the proper action type')
    equal(
      response.errors.termTooShort,
      'Search term must be at least 4 characters',
      'the error is set with the proper number'
    )
    done()
  }

  const fakeGetStateSearchLengthTooShort = () => ({
    userList: {
      searchFilter: {
        search_term: 'a'
      }
    }
  })

  const fakeUserStore = {
    load() {
      return Promise.resolve([STUDENTS[0]])
    }
  }

  const actionThunk = actions.applySearchFilter(4, fakeUserStore)

  equal(typeof actionThunk, 'function', 'it initally returns a callback function')

  actionThunk(fakeDispatcherSearchLengthOkay, fakeGetStateSearchLengthOkay)
  actionThunk(fakeDispatcherSearchLengthTooShort, fakeGetStateSearchLengthTooShort)
})
