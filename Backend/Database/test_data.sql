INSERT INTO users (email, display_name, password_hash, bio, preferences, location_lat, location_lon) VALUES
('Devnull@darkrage.com', 'Devnull', 'hashed_password1', 'I push big red buttons.', NULL, 59.334591, 18.063240),
('Orsi@darkrage.com', 'Orsi', 'hashed_password2', 'I squeak on Mondays.', NULL, 57.708870, 11.974560),
('Rando@darkrage.com', 'John', 'hashed_password3', 'Life is short, code faster.', NULL, 60.128161, 18.643501),
('Rando1@darkrage.com', 'Sam', 'hashed_password3', 'Coffee powers my mind.', NULL, 56.046467, 12.694512),
('Rando2@darkrage.com', 'Steve', 'hashed_password3', 'I chase bright ideas.', NULL, 63.825847, 20.263035),
('Eve@darkrage.com', 'Eve', 'hashed_password3', 'Puzzle-solving is my passion.', NULL, 65.584819, 22.154259),
('Josh@darkrage.com', 'Josh', 'hashed_password3', 'I debug in my sleep.', NULL, 62.390812, 17.306927),
('Gil@darkrage.com', 'Gil', 'hashed_password3', 'Warm socks on cold days.', NULL, 59.858564, 17.638927),
('Dug@darkrage.com', 'Rebecca', 'hashed_password3', 'Reading vintage mysteries.', NULL, 58.410807, 15.621373),
('Amanda@darkrage.com', 'Amanda', 'hashed_password3', 'Quirkiness is underrated.', NULL, 56.161224, 15.586900),
('Gene@darkrage.com', 'Gene', 'hashed_password3', 'I dream of sushi.', NULL, 55.604981, 13.003822),
('Louise@darkrage.com', 'Louise', 'hashed_password3', 'I dance with variables.', NULL, 59.049190, 15.039311),
('Carla@darkrage.com', 'Carla', 'hashed_password3', 'Bugs fear my code.', NULL, 62.198164, 14.641629),
('Irene@darkrage.com', 'Irene', 'hashed_password3', 'Records spin my thoughts.', NULL, 59.703247, 14.187016),
('Errol@darkrage.com', 'Errol', 'hashed_password3', 'I chase moose sightings.', NULL, 66.008841, 17.981998),
('tester@tester.com', 'Tester', '$2b$12$wris9R1LA8Qd5/74oOMg1uU2nbVLv2UqaYEqM1pg3t2uDhoZlj8Lm', 'Testing account.', NULL, 62.008841, 16.981998);

INSERT INTO user_pictures (user_id, picture_url, is_profile_picture) VALUES
(1, '1.jpg', TRUE),
(1, '1.jpg', FALSE),
(2, '2.jpg', TRUE),
(2, '2.jpg', FALSE),
(3, '3.jpg', TRUE),
(3, '3.jpg', FALSE),
(4, '4.jpg', TRUE),
(4, '4.jpg', FALSE),
(5, '5.jpg', TRUE),
(5, '5.jpg', FALSE),
(6, '6.jpg', TRUE),
(6, '6.jpg', FALSE),
(7, '7.jpg', TRUE),
(7, '7.jpg', FALSE),
(8, '8.jpg', TRUE),
(8, '8.jpg', FALSE),
(9, '9.jpg', TRUE),
(9, '9.jpg', FALSE),
(10, '10.jpg', TRUE),
(10, '10.jpg', FALSE),
(11, '11.jpg', TRUE),
(11, '11.jpg', FALSE),
(12, '12.jpg', TRUE),
(12, '12.jpg', FALSE),
(13, '13.jpg', TRUE),
(13, '13.jpg', FALSE),
(14, '14.jpg', TRUE),
(14, '14.jpg', FALSE),
(15, '15.jpg', TRUE),
(15, '15.jpg', FALSE);

INSERT INTO user_interests (user_id, interest) VALUES
(1, 'Sleap'),
(1, 'Eat'),
(1, 'Fifa'),
(2, 'Scratching'),
(2, 'Eating'),
(2, 'Meowing'),
(3, 'Suffer');

INSERT INTO matches (user_id_1, user_id_2, match_score, is_matched) VALUES
(1, 2, 1, TRUE),
(3, 1, 1, FALSE),
(3, 2, 0, FALSE),
(16, 6, 1, TRUE);

INSERT INTO messages (match_id, sender_id, message_text) VALUES
(1, 1, 'Grr'),
(1, 2, 'Grrr'),
(1, 1, 'Grrrr'),
(4, 6, 'Hello!'),
(4, 16, 'Hi! How are you?');