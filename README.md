# zhumakan-zhanadil-devops

Laboratory work 1 for the DevOps course: Linux, Git, GitHub, Docker and Jenkins.

| | |
|---|---|
| Student | Zhanadil Zhumakan |
| Group | IT2-2304 |
| Student ID | 38093 |

## Project structure

```
zhumakan_zhanadil/
├── app/app.py                          # Python app that shows student info (web server on port 8000)
├── config/app.conf                     # default configuration
├── scripts/Zhumakan_Zhanadil_system.sh # student + system information script
├── scripts/test_project.sh             # checks used in Jenkins "Test" stage
├── logs/                               # application logs (*.log are not tracked by git)
├── backup/                             # local backups (not tracked by git)
├── jenkins/                            # Jenkins in Docker with Docker CLI, plugins and the job
├── Zhumakan_Zhanadil_info.txt
├── Dockerfile
├── docker-compose.yml
└── Jenkinsfile
```

## Run the system script

```bash
chmod +x scripts/Zhumakan_Zhanadil_system.sh
./scripts/Zhumakan_Zhanadil_system.sh
```

## Run with Docker

```bash
docker build -t zhumakan-zhanadil-devops .
docker run -d --name zhumakan-zhanadil-container -p 8000:8000 zhumakan-zhanadil-devops
docker logs zhumakan-zhanadil-container
```

The app is available at http://localhost:8000

Student data can be changed with environment variables:
`STUDENT_NAME`, `STUDENT_SURNAME`, `STUDENT_GROUP`, `STUDENT_ID`.

## Run with Docker Compose

```bash
docker compose up -d
docker compose ps
docker compose down
```

## Jenkins

Pipeline stages: Checkout → Build → Test → Docker Build → Docker Run.

Jenkins itself runs in Docker (folder `jenkins/`). The image already has the Docker CLI,
the Pipeline and Git plugins and the job `Zhumakan_Zhanadil_DevOps` (`jenkins/job-config.xml`),
so it is ready after one command:

```bash
cd jenkins
docker compose up -d --build
```

Then open http://localhost:8080 and press **Build Now** in the job.
