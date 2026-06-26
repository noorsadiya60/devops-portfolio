import http from 'k6/http';

export const options = {
  vus: 200,
  duration: '3m',
};

export default function () {
  http.get('http://localhost:3000/');
}