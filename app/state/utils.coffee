'use strict'


module.exports =

  UUIDv4: do ->
    sectionLengths = [8, 4, 4, 4, 12]
    versionSectionIndex = 2
    variantSectionIndex = 3

    UUIDv4 = ->
      sections = for length, index in sectionLengths
        bytes = crypto.getRandomValues new Uint8Array length

        if index is versionSectionIndex then bytes[0] = 4
        if index is variantSectionIndex then bytes[0] = 8 + (bytes[0] % 4)

        ((byte % 16).toString 16 for byte in bytes).join('')

      sections.join('-')
