
_ = require 'underscore'
vows = require 'vows'
assert = require 'assert'
dw = require '../dw.js'


formats =
    '1234.5': [-13363.28, 40211.93, 7947.34, 3818.72, 45181.09, 4017.77]
    '1234': ['-13363', '40212', '7947', '3819', '45181', '4018', '38681', '31552', '-14216', '38479', '-24131', '-48902', '28567', '743', '28324', '26446', '35948', '-43687', '49140', '17597', '23847', '12167', '24885', '31393', '16453', '-42788', '21017', '4647', '10721', '11091', '27875', '-13968', '42165', '487', '-11276', '25426', '-34332', '-33182', '-23273', '4333', '13135', '2753', '41574', '31647', '-47673', '25742', '4758', '-31039', '-14942', '-37304']
    '1234.56': ['-13363.28', '40211.93', '7947.34', '3818.72', '45181.09', '4017.77', '38681.04', '31551.56', '-14216.48', '38478.75', '-24130.93', '-48902.43', '28566.59', '743.02', '28323.52', '26445.68', '35947.51', '-43687.13', '49140.37', '17597.26', '23847.35', '12167.33', '24885.12', '31392.84', '16453.37', '-42788.16', '21017.46', '4647.01', '10720.83', '11090.89', '27874.91', '-13968.43', '42165.49', '487.35', '-11275.56', '25425.86', '-34332.45', '-33181.69', '-23272.72', '4332.98', '13135.42', '2753.29', '41574.28', '31646.61', '-47672.87', '25742.26', '4757.60', '-31038.57', '-14942.06', '-37303.72']
    '1,234': ['-13,363', '40,212', '7,947', '3,819', '45,181', '4,018', '38,681', '31,552', '-14,216', '38,479', '-24,131', '-48,902', '28,567', '743', '28,324', '26,446', '35,948', '-43,687', '49,140', '17,597', '23,847', '12,167', '24,885', '31,393', '16,453', '-42,788', '21,017', '4,647', '10,721', '11,091', '27,875', '-13,968', '42,165', '487', '-11,276', '25,426', '-34,332', '-33,182', '-23,273', '4,333', '13,135', '2,753', '41,574', '31,647', '-47,673', '25,742', '4,758', '-31,039', '-14,942', '-37,304']
    '1,234.56': ['-13,363.28', '40,211.93', '7,947.34', '3,818.72', '45,181.09', '4,017.77', '38,681.04', '31,551.56', '-14,216.48', '38,478.75', '-24,130.93', '-48,902.43', '28,566.59', '743.02', '28,323.52', '26,445.68', '35,947.51', '-43,687.13', '49,140.37', '17,597.26', '23,847.35', '12,167.33', '24,885.12', '31,392.84', '16,453.37', '-42,788.16', '21,017.46', '4,647.01', '10,720.83', '11,090.89', '27,874.91', '-13,968.43', '42,165.49', '487.35', '-11,275.56', '25,425.86', '-34,332.45', '-33,181.69', '-23,272.72', '4,332.98', '13,135.42', '2,753.29', '41,574.28', '31,646.61', '-47,672.87', '25,742.26', '4,757.60', '-31,038.57', '-14,942.06', '-37,303.72']
    '1234,56': ['-13363,28', '40211,93', '7947,34', '3818,72', '45181,09', '4017,77', '38681,04', '31551,56', '-14216,48', '38478,75', '-24130,93', '-48902,43', '28566,59', '743,02', '28323,52', '26445,68', '35947,51', '-43687,13', '49140,37', '17597,26', '23847,35', '12167,33', '24885,12', '31392,84', '16453,37', '-42788,16', '21017,46', '4647,01', '10720,83', '11090,89', '27874,91', '-13968,43', '42165,49', '487,35', '-11275,56', '25425,86', '-34332,45', '-33181,69', '-23272,72', '4332,98', '13135,42', '2753,29', '41574,28', '31646,61', '-47672,87', '25742,26', '4757,60', '-31038,57', '-14942,06', '-37303,72']
    '1.234': ['-13.363', '40.212', '7.947', '3.819', '45.181', '4.018', '38.681', '31.552', '-14.216', '38.479', '-24.131', '-48.902', '28.567', '743', '28.324', '26.446', '35.948', '-43.687', '49.140', '17.597', '23.847', '12.167', '24.885', '31.393', '16.453', '-42.788', '21.017', '4.647', '10.721', '11.091', '27.875', '-13.968', '42.165', '487', '-11.276', '25.426', '-34.332', '-33.182', '-23.273', '4.333', '13.135', '2.753', '41.574', '31.647', '-47.673', '25.742', '4.758', '-31.039', '-14.942', '-37.304']
    '1.234,56': ['-13.363,28', '40.211,93', '7.947,34', '3.818,72', '45.181,09', '4.017,77', '38.681,04', '31.551,56', '-14.216,48', '38.478,75', '-24.130,93', '-48.902,43', '28.566,59', '743,02', '28.323,52', '26.445,68', '35.947,51', '-43.687,13', '49.140,37', '17.597,26', '23.847,35', '12.167,33', '24.885,12', '31.392,84', '16.453,37', '-42.788,16', '21.017,46', '4.647,01', '10.720,83', '11.090,89', '27.874,91', '-13.968,43', '42.165,49', '487,35', '-11.275,56', '25.425,86', '-34.332,45', '-33.181,69', '-23.272,72', '4.332,98', '13.135,42', '2.753,29', '41.574,28', '31.646,61', '-47.672,87', '25.742,26', '4.757,60', '-31.038,57', '-14.942,06', '-37.303,72']
    '1 234': ['-13 363', '40 212', '7 947', '3 819', '45 181', '4 018', '38 681', '31 552', '-14 216', '38 479', '-24 131', '-48 902', '28 567', '743', '28 324', '26 446', '35 948', '-43 687', '49 140', '17 597', '23 847', '12 167', '24 885', '31 393', '16 453', '-42 788', '21 017', '4 647', '10 721', '11 091', '27 875', '-13 968', '42 165', '487', '-11 276', '25 426', '-34 332', '-33 182', '-23 273', '4 333', '13 135', '2 753', '41 574', '31 647', '-47 673', '25 742', '4 758', '-31 039', '-14 942', '-37 304']
    '1 234,56': ['-13 363,28', '40 211,93', '7 947,34', '3 818,72', '45 181,09', '4 017,77', '38 681,04', '31 551,56', '-14 216,48', '38 478,75', '-24 130,93', '-48 902,43', '28 566,59', '743,02', '28 323,52', '26 445,68', '35 947,51', '-43 687,13', '49 140,37', '17 597,26', '23 847,35', '12 167,33', '24 885,12', '31 392,84', '16 453,37', '-42 788,16', '21 017,46', '4 647,01', '10 720,83', '11 090,89', '27 874,91', '-13 968,43', '42 165,49', '487,35', '-11 275,56', '25 425,86', '-34 332,45', '-33 181,69', '-23 272,72', '4 332,98', '13 135,42', '2 753,29', '41 574,28', '31 646,61', '-47 672,87', '25 742,26', '4 757,60', '-31 038,57', '-14 942,06', '-37 303,72']


batch = {}

for k of formats

    batch[k] =
        'topic': dw.column 'name', formats[k]
        'type number': (topic) -> assert.equal topic.type(), 'number'

vows
    .describe('Some tests for different number formats')
    .addBatch(batch)
    .export module
